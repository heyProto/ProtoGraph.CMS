# == Schema Information
#
# Table name: view_casts
#
#  id                  :integer          not null, primary key
#  account_id          :integer
#  datacast_identifier :string(255)
#  template_card_id    :integer
#  template_datum_id   :integer
#  name                :string(255)
#  optionalConfigJSON  :text(65535)
#  cdn_url             :text(65535)
#  slug                :string(255)
#  created_by          :integer
#  updated_by          :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  seo_blockquote      :text(65535)
#

class ViewCast < ApplicationRecord
    #CONSTANTS
    Datacast_ENDPOINT = "#{ENV['AWS_S3_ENDPOINT']}/Datacasts"
    #CUSTOM TABLES
    #GEMS
    extend FriendlyId
    friendly_id :name, use: :slugged
    #ASSOCIATIONS
    belongs_to :account
    belongs_to :template_datum
    belongs_to :template_card
    belongs_to :creator, class_name: "User", foreign_key: "created_by"
    belongs_to :updator, class_name: "User", foreign_key: "updated_by"

    #ACCESSORS
    attr_accessor :dataJSON, :schemaJSON
    #VALIDATIONS

    #CALLBACKS
    before_create :before_create_set
    before_save :before_save_set
    #SCOPE
    #OTHER

    def remote_urls
        {
            "data_url": "#{Datacast_ENDPOINT}/#{self.datacast_identifier}.json",
            "configuration_url": self.cdn_url,
            "schema_json": "#{self.template_datum.schema_json}"
        }
    end

    def remove_file
        Api::ProtoGraph::Utility.remove_from_cdn(self.cdn_url)
    end
    #PRIVATE
    private

    def before_create_set
        self.datacast_identifier = SecureRandom.hex(12)
    end

    def before_save_set
        if self.optionalConfigJSON_changed? and self.optionalConfigJSON.present?
            key = "ViewCasts/#{self.slug}.json"
            encoded_file = Base64.encode64(self.optionalConfigJSON)
            content_type = "application/json"
            resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, key, content_type)
            self.cdn_url = resp.first["s3_endpoint"]
        end
    end
end
