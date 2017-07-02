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
    attr_accessor :dataJSON, :schemaJSON, :stop_callback
    #VALIDATIONS

    #CALLBACKS
    before_create :before_create_set
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
        "#{Datacast_ENDPOINT}/#{self.datacast_identifier}.json"
    end

    def remove_file
        Api::ProtoGraph::Utility.remove_from_cdn(self.cdn_url)
    end

    def social_urls
        {
            "twitter": "#{ENV['AWS_S3_ENDPOINT']}/Previews/#{self.id}_twitter.png",
            "facebook": "#{ENV['AWS_S3_ENDPOINT']}/Previews/#{self.id}_facebook.png",
            "instagram": "#{ENV['AWS_S3_ENDPOINT']}/Previews/#{self.id}_instagram.png"
        }
    end


    def save_png(mode="")
        payload = {}
        key = "Previews/#{self.id}#{ mode.present? ? "_#{mode}" : ""}.png"
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
            status_obj = JSON.parse(self.status || {}.to_json)
            status_obj['screenshot'] = true
            if mode.blank?
                self.update_attributes(render_screenshot_url: html_url, status: status_obj.to_json, stop_callback: true)
            else
                status_obj = JSON.parse(self.status || {}.to_json)
                status_obj[mode] = true
                self.update_attributes(status: status_obj.to_json, stop_callback: true)
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
            key = "ViewCasts/#{self.slug}.json"
            encoded_file = Base64.encode64(self.optionalConfigJSON)
            content_type = "application/json"
            resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, key, content_type)
            self.cdn_url = resp.first["s3_endpoint"]
        end
        self.status = {}.to_json if self.status.blank?
    end

    def after_save_set
        if self.saved_changes? and !self.stop_callback
            Thread.new do
                self.save_png
                if self.template_card.git_repo_name == 'ProtoGraph.Card.toSocial'
                    self.save_png('twitter')
                    self.save_png('instagram')
                    self.save_png('facebook')
                end
                ActiveRecord::Base.connection.close
            end
        end
    end
end
