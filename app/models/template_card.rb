# == Schema Information
#
# Table name: template_cards
#
#  id                  :integer          not null, primary key
#  account_id          :integer
#  name                :string(255)
#  elevator_pitch      :string(255)
#  description         :text(65535)
#  global_slug         :string(255)
#  is_current_version  :boolean
#  slug                :string(255)
#  version_series      :string(255)
#  previous_version_id :integer
#  version_genre       :string(255)
#  version             :string(255)
#  change_log          :text(65535)
#  status              :string(255)
#  publish_count       :integer
#  is_public           :boolean
#  git_url             :text(65535)
#  git_branch          :string(255)      default("master")
#  created_by          :integer
#  updated_by          :integer
#  template_datum_id   :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  has_static_image    :boolean          default(FALSE)
#

class TemplateCard < ApplicationRecord

    include Associable
    include Versionable
    #CONSTANTS
    STATUS = ["Draft", "Ready to Publish", "Published", "Deactivated"]
    CDN_BASE_URL = "#{ENV['AWS_S3_ENDPOINT']}/cards"

    #CUSTOM TABLES
    #GEMS
    extend FriendlyId
    friendly_id :slug_candidates, use: :scoped, scope: [:account_id]

    #ASSOCIATIONS
    belongs_to :template_datum
    belongs_to :account
    # has_one :html, ->{where(genre: "html", attachable_type: "TemplateCard")}, class_name: "ServicesAttachable", foreign_key: "attachable_id"
    # has_one :css, ->{where(genre: "css", attachable_type: "TemplateCard")}, class_name: "ServicesAttachable", foreign_key: "attachable_id"
    # has_one :js, ->{where(genre: "js", attachable_type: "TemplateCard")}, class_name: "ServicesAttachable", foreign_key: "attachable_id"
    # has_one :config, ->{where(genre: "config", attachable_type: "TemplateCard")}, class_name: "ServicesAttachable", foreign_key: "attachable_id"
    # has_one :image, ->{where(genre: "image", attachable_type: "TemplateCard")}, class_name: "ServicesAttachable", foreign_key: "attachable_id"
    # has_one :logo, ->{where(genre: "logo", attachable_type: "TemplateCard")}, class_name: "ServicesAttachable", foreign_key: "attachable_id"


    #ACCESSORS
    attr_accessor :previous_version_id

    #VALIDATIONS
    validates :account_id, presence: true
    validates :template_datum_id, presence: true
    validates :name, presence: true
    validates :created_by, presence: true
    validates :updated_by, presence: true

    #CALLBACKS
    before_create :before_create_set
    after_create :after_create_set

    #SCOPE
    #OTHER
    def slug_candidates
        ["#{self.name}-#{self.version.to_s}"]
    end

    def deep_copy_across_versions
        p                           = self.previous
        v                           = p.version.to_s.to_version
        if self.version_genre == "major"
            self.version            = v.bump!(:major).to_s
        elsif self.version_genre == "minor"
            self.version            = v.bump!(:minor).to_s
        elsif self.version_genre == "bug"
            self.version            = v.bump!.to_s
        end
        self.account_id             = p.account_id
        self.name                   = p.name
        self.global_slug            = p.global_slug
        self.is_current_version     = false
        self.is_public              = p.is_public
        self.version_series         = self.version.to_s.to_version.to_a[0]
        self.description            = p.description
        self.elevator_pitch         = p.elevator_pitch
    end

    def can_make_public?
        (self.status == "Published" and self.template_datum.is_public) ? true : false
    end

    def can_ready_to_publish?
        if self.template_datum.status == "Published" and
           self.html.file_url.present? and
           self.css.file_url.present? and
           self.js.file_url.present? and
           self.config.file_url.present? and
           self.logo.file_url.present?  and
           self.image.file_url.present? and
           self.description.present?
                return true
        end
        return false
    end

    def account_slug
        self.account.slug
    end

    def icon_url
        "#{base_url}/card.png"
    end

    def versions
        #self.siblings.where.not(id:  self.id).as_json(only: [:account_id, :id, :slug, :global_slug,:name, :elevator_pitch], methods: [:account_slug, :icon_url])
        #uncomment after testing
        self.siblings.as_json(only: [:account_id, :id, :slug, :global_slug,:name, :elevator_pitch], methods: [:account_slug, :icon_url])
    end

    def base_url
        "#{TemplateCard::CDN_BASE_URL}/#{self.name}/dist/#{self.version}"
    end

    def js
        "#{base_url}/card.min.js"
        # "http://192.168.2.7:8001/dist/0.0.1/card.min.js"
    end

    def css
        "#{base_url}/card.min.css"
        # "http://192.168.2.7:8001/dist/0.0.1/card.min.css"
    end

    def files
        obj = {
            "js": "#{js}",
            "css": "#{css}",
            "html": "#{index_html}",
            "configuration_schema": "#{base_url}/configuration_schema.json",
            "configuration_sample": "#{base_url}/configuration_sample.json",
            # "configuration_schema": "http://192.168.2.7:8001/dist/0.0.1/configuration_schema.json",
            # "configuration_sample": "http://192.168.2.7:8001/dist/0.0.1/configuration_sample.json",
            "icon_url": "#{icon_url}",
            "schema_files": self.template_datum.files
        }

        obj["static_image"] = "#{base_url}/static_image.png" if self.has_static_image
        obj
    end

    def index_html
        "#{base_url}/index.html"
    end


    #PRIVATE
    private

    def should_generate_new_friendly_id?
        slug.blank? || name_changed?
    end

    def before_create_set
        self.status = "Draft"
        self.publish_count = 0
        if self.previous_version_id.blank?
            self.global_slug = self.name.parameterize
            self.is_current_version = true
            self.version_series = "0"
            self.previous_version_id = nil
            self.version_genre = "major"
            self.version = "0.0.1"
            self.is_public = false
        end
        true
    end

    def after_create_set
        # ServicesAttachable.create_shell_object(self, "html")
        # ServicesAttachable.create_shell_object(self, "js")
        # ServicesAttachable.create_shell_object(self, "css")
        # ServicesAttachable.create_shell_object(self, "config")
        # ServicesAttachable.create_shell_object(self, "logo")
        # ServicesAttachable.create_shell_object(self, "image")
        true
    end
end
