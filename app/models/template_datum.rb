# == Schema Information
#
# Table name: template_data
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  global_slug   :string(255)
#  slug          :string(255)
#  version       :string(255)
#  change_log    :text(65535)
#  publish_count :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  status        :string(255)
#

class TemplateDatum < ApplicationRecord

    include Versionable
    include Associable
    #CONSTANTS
    CDN_BASE_URL = "#{ENV['AWS_S3_ENDPOINT']}/Schemas"
    #CUSTOM TABLES
    #GEMS
    require 'version'
    extend FriendlyId
    friendly_id :slug_candidates, use: :scoped

    #ASSOCIATIONS
    has_many :template_cards

    #ACCESSORS
    #VALIDATIONS
    validates :name, presence: true

    #CALLBACKS
    before_create :before_create_set

    #SCOPE
    #OTHER
    #TODO: Write a background job to connect to the git repo and the git branch, and upload the file from /build/#version_no./ folder


    def slug_candidates
        ["#{self.name}-#{self.version.to_s}"]
    end

    def files
        {
            "schema": "#{schema_json}",
            "sample": "#{TemplateDatum::CDN_BASE_URL}/#{self.name}/#{self.version}/sample.json"
        }
    end

    def schema_json
        "#{TemplateDatum::CDN_BASE_URL}/#{self.name}/#{self.version}/schema.json"
    end

    #PRIVATE
    private

    def should_generate_new_friendly_id?
        slug.blank? || name_changed?
    end

    def before_create_set
        self.publish_count = 0
        if self.previous_version_id.blank?
            self.global_slug = self.name.parameterize
        end
        true
    end

end
