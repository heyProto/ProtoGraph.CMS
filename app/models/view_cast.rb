# == Schema Information
#
# Table name: view_casts
#
#  id                    :integer          not null, primary key
#  account_id            :integer
#  datacast_identifier   :string(255)
#  template_card_id      :integer
#  template_datum_id     :integer
#  name                  :string(255)
#  optionalConfigJSON    :text(65535)
#  cdn_url               :text(65535)
#  slug                  :string(255)
#  created_by            :integer
#  updated_by            :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  seo_blockquote        :text(65535)
#  render_screenshot_url :text(65535)
#  status                :text(65535)
#

class ViewCast < ApplicationRecord
    #CONSTANTS
    Datacast_ENDPOINT = "#{ENV['AWS_S3_ENDPOINT']}"
    Platforms = ['facebook', 'twitter', 'instagram']
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
    attr_accessor :dataJSON, :schemaJSON, :stop_callback
    #VALIDATIONS

    #CALLBACKS
    before_create :before_create_set
    after_create :after_create_set
    before_save :before_save_set
    after_save :after_save_set
    #SCOPE
    #OTHER

    def remote_urls
        {
            "data_url": self.data_url,
            "configuration_url": self.cdn_url,
            "schema_json": self.schema_json
        }
    end

    def schema_json
        "#{self.template_datum.schema_json}"
    end

    def data_url
        "#{Datacast_ENDPOINT}/#{self.datacast_identifier}/data.json"
    end

    def remove_file
        Api::ProtoGraph::Utility.remove_from_cdn(self.cdn_url)
    end

    def social_urls
        {
            "twitter": "#{ENV['AWS_S3_ENDPOINT']}/#{self.datacast_identifier}/#{self.id}_twitter.png",
            "facebook": "#{ENV['AWS_S3_ENDPOINT']}/#{self.datacast_identifier}/#{self.id}_facebook.png",
            "instagram": "#{ENV['AWS_S3_ENDPOINT']}/#{self.datacast_identifier}/#{self.id}_instagram.png"
        }
    end


    def save_png(mode="")
        payload = {}
        key = "#{self.datacast_identifier}/#{self.id}#{ mode.present? ? "_#{mode}" : ""}.png"
        template_card = self.template_card
        files = template_card.files
        payload["js"] = files[:js]
        payload["css"] = files[:css]
        payload["data_url"] = self.data_url
        payload["schema_json"] = self.schema_json
        payload["configuration_url"] = self.cdn_url
        payload["configuration_schema"] = files[:configuration_schema]
        payload["initializer"] = template_card.git_repo_name
        payload["key"] = key
        payload["mode"] = mode.blank? ? 'screenshot' : mode
        html_url = "#{ENV['AWS_S3_ENDPOINT']}/#{key}"
        response = Api::ProtoGraph::ViewCast.render_screenshot(payload)
        unless response['errorMessage'].present?
            if mode.blank?
                self.update_columns(render_screenshot_url: html_url, updated_at: Time.now)
            else
                status_obj = JSON.parse(self.status)
                status_obj[mode] = "success"
                self.update_columns(status: status_obj.to_json, updated_at: Time.now)
            end
        else
            if mode.present?
                status_obj = JSON.parse(self.status)
                status_obj[mode] = "success"
                self.update_columns(status: status_obj.to_json, updated_at: Time.now)
            end
        end
    end

    class << self
        def create_missing_images
            ViewCast.where(render_screenshot_url: nil).each do |view_cast|
                view_cast.save_png
            end
        end
    end
    #PRIVATE
    private

    def before_create_set
        self.datacast_identifier = SecureRandom.hex(12)
        self.optionalConfigJSON = {} if self.optionalConfigJSON.blank?
    end

    def before_save_set
        if self.optionalConfigJSON_changed? and self.optionalConfigJSON.present?
            self.datacast_identifier = SecureRandom.hex(12) if self.datacast_identifier.blank?
            key = "#{self.datacast_identifier}/view_cast.json"
            encoded_file = Base64.encode64(self.optionalConfigJSON)
            content_type = "application/json"
            resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, key, content_type)
            self.cdn_url = resp.first["s3_endpoint"]
        end
        if self.status.blank?
            self.status = {"twitter": "creating", "facebook": "creating", "instagram": "creating"}.to_json
        end
    end

    def after_save_set
        if self.saved_changes? and !self.stop_callback
            Thread.new do
                if self.template_card.git_repo_name == 'ProtoGraph.Card.toSocial'
                    ViewCast::Platforms.each do |mode|
                        self.save_png(mode)
                    end
                end
                self.save_png
                ActiveRecord::Base.connection.close
            end
        end
    end

    def after_create_set
        template_card = self.template_card
        template_card.update_attributes(publish_count: (template_card.publish_count.to_i + 1))
        template_datum = self.template_datum
        template_datum.update_attributes(publish_count: (template_datum.publish_count.to_i + 1))
    end
end
