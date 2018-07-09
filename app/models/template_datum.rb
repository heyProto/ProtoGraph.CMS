# == Schema Information
#
# Table name: template_data
#
#  id            :bigint(8)        not null, primary key
#  name          :string(255)
#  global_slug   :string(255)
#  slug          :string(255)
#  version       :string(255)
#  change_log    :text
#  publish_count :bigint(8)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  status        :string(255)
#  s3_identifier :string(255)
#  created_by    :bigint(8)
#  updated_by    :bigint(8)
#

#TODO AMIT - Handle created_by, updated_by - RP added retrospectively. Need migration of old rows and BAU handling.

class TemplateDatum < ApplicationRecord

  #CONSTANTS
  CDN_BASE_URL = "#{ENV['AWS_S3_ENDPOINT']}"

  #CUSTOM TABLES
  #GEMS
  require 'version'
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  #CONCERNS
  include AssociableBy
  include Versionable
  #ASSOCIATIONS
  has_many :template_cards
  has_many :template_fields
  has_many :view_casts, through: :template_cards

  #ACCESSORS
  #VALIDATIONS
  validates :name, presence: true
  #CALLBACKS
  before_create :before_create_set
  before_destroy :before_destroy_set

  #SCOPE
  #OTHER
  #TODO: Write a background job to connect to the git repo and the git branch, and upload the file from /build/#version_no./ folder

  def cdn_bucket
    Rails.env.production? ? "cdn.protograph" : "dev.cdn.protograph"
  end

  def slug_candidates
    ["#{self.name}-#{self.version.to_s}"]
  end

  def files
    {
      "schema": "#{schema_json}",
      "sample": "#{TemplateDatum::CDN_BASE_URL}/#{self.s3_identifier}/sample.json"
    }
  end

  def schema_json
    "#{TemplateDatum::CDN_BASE_URL}/#{self.s3_identifier}/schema.json"
  end

  def invalidate
    Api::ProtoGraph::CloudFront.invalidate(nil,["/#{self.s3_identifier}/*"], 1)
  end


  class << self
    def create_or_update(params)
      a = TemplateDatum.where(name: params["name"], version: params["version"]).first
      if a.blank?
        a = TemplateDatum.create(name: params["name"], version: params["version"], status: params["status"], change_log: params["change_log"])
        return [a, true]
      else
        return [a, false] if a.publish_count > 0
        a.update_attributes(status: params["status"], change_log: params["change_log"])
        return [a, true]
      end
    end
  end

  def get_schema_json
    fields = self.template_fields
    json_schema = {
      "$schema": "http://json-schema.org/draft-04/schema#",
      "properties": {
        "data": {
          "id": "/properties/data"
        }
      }
    }
    properties = {}
    reqs = []
    fields.each do |field|
      field_key = field.key_name
      field_name = field.name
      field_type = %w(short_text long_text).include?(field.data_type) ? "string" : field.data_type

      properties[field_key] = {
        "id": "/properties/data/properties/#{field_key}",
        "title": field_name,
        "type": field_type
      }

      if field.is_required.present? and field.is_required == true
        reqs << field_key
      end

      if field.default_value.present?
        properties[field_key]["default"] = field.default_value
      end

      if field.inclusion_list.present?
        properties[field_key]["enum"] = field.inclusion_list
      end

      if field.inclusion_list_names.present?
        properties[field_key]["enum_names"] = field.inclusion_list_names
      end

      if ["decimal", "integer"].include?(field_type)
        if field.min.present?
          properties[field_key][:minimum] = field.min
        end
        if field.max.present?
          properties[field_key][:maximum] = field.max
        end
        if field.multiple_of.present?
          properties[field_key][:multipleOf] = field.multiple_of
        end
        if field.ex_min.present?
          properties[field_key][:exclusiveMinimum] = field.ex_min
        end
        if field.ex_max.present?
          properties[field_key][:exclusiveMaximum] = field.ex_max
        end
      elsif %w(short_text long_text).include?(field_type)
        if field.format.present?
          properties[field_key][:format] = field.format
        end
        if field.pattern.present?
          properties[field_key][:pattern] = field.format_regex
        end
        if field.min_length
          properties[field_key][:minLength] = field.length_minimum
        end
        if field.max_length
          properties[field_key][:maxLength] = field.length_maximum
        end
      end
    end
    json_schema[:properties][:required] = reqs if reqs.length > 0
    json_schema[:properties][:data][:properties] = properties
    return json_schema
  end

  def upload_to_s3
    puts "upload to s3"
    new_schema_json = self.get_schema_json
    begin
      url = self.schema_json
      old_schema_json = JSON.parse(open(url).read)
      merged_schema = self.merge_schema(old_schema_json, new_schema_json)
      key = "#{self.s3_identifier}/schema.json"
      encoded_file = Base64.encode64(merged_schema.to_json)
      content_type = "application/json"
      resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, key, content_type, self.cdn_bucket)
      self.invalidate
    rescue e
      puts "#{e}:Could not fetch original schema"
    end
  end

  def merge_schema(old_schema, new_schema)
    json_schema = {
      "$schema": "http://json-schema.org/draft-04/schema#",
      "properties": {
        "data": {
          "id": "/properties/data",
          "properties": {

          }
        }
      }
    }
    old_fields = old_schema["properties"]["data"]["properties"]
    new_fields = new_schema[:properties][:data][:properties]
    properties = {}
    new_fields.each do |key, val|
      if old_fields.key?(key)
        if ["array", "object"].include?(val["type"])
          properties[key] = old_fields[key]
        else
          properties[key] = val
        end
      else
        properties[key] = val
      end
    end
    json_schema[:properties][:data][:properties] = properties
    return json_schema
  end


  #PRIVATE
  private

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def before_create_set
    self.publish_count = 0
    self.global_slug = self.name.parameterize
    self.s3_identifier = SecureRandom.hex(6) if self.s3_identifier.blank?
    true
  end

  def before_destroy_set
    self.template_cards.destroy_all
  end

end
