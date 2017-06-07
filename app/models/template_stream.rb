# == Schema Information
#
# Table name: template_streams
#
#  id                 :integer          not null, primary key
#  account_id         :integer
#  name               :string(255)
#  elevator_pitch     :string(255)
#  description        :text(65535)
#  slug               :string(255)
#  global_slug        :string(255)
#  version            :float(24)
#  is_current_version :boolean
#  change_log         :text(65535)
#  status             :string(255)
#  publish_count      :integer
#  is_public          :boolean
#  created_by         :integer
#  updated_by         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class TemplateStream < ApplicationRecord

    #CONSTANTS
    #CUSTOM TABLES
    #GEMS
    extend FriendlyId
    friendly_id :slug_candidates, use: :scoped, scope: [:account_id]

    #ASSOCIATIONS
    belongs_to :account
    belongs_to :creator, class_name: "User", foreign_key: "created_by"
    belongs_to :updator, class_name: "User", foreign_key: "updated_by"
    has_many :template_stream_cards, dependent: :destroy
    has_many :template_cards, through: :template_stream_cards
    has_one :html, ->{where(genre: "html", attachable_type: "TemplateStream")}, class_name: "ServicesAttachable", foreign_key: "attachable_id"
    has_one :css, ->{where(genre: "css", attachable_type: "TemplateStream")}, class_name: "ServicesAttachable", foreign_key: "attachable_id"
    has_one :js, ->{where(genre: "js", attachable_type: "TemplateStream")}, class_name: "ServicesAttachable", foreign_key: "attachable_id"
    has_one :config, ->{where(genre: "config", attachable_type: "TemplateStream")}, class_name: "ServicesAttachable", foreign_key: "attachable_id"

    #ACCESSORS
    attr_accessor :previous_version_id

    #VALIDATIONS
    validates :account_id, presence: true
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

    def parent
        TemplateStream.where(global_slug: self.global_slug, is_current_version: true).first
    end

    def siblings
        TemplateStream.where(global_slug: self.global_slug)
    end

    #PRIVATE
    private

    def should_generate_new_friendly_id?
        slug.blank? || name_changed?
    end

    def before_create_set
        self.status = "Draft"
        self.publish_count = 0
        if self.global_slug.blank?
            self.version = 0.1
            self.is_public = false
            self.global_slug = self.name.gsub(" ", "-").downcase #TODO AMIT is there a better way to sluggify?
            self.is_current_version = true
        else
            self.is_public = self.parent.is_public
            self.description = self.parent.description
            self.elevator_pitch = self.parent.elevator_pitch
        end
        true
    end

    def after_create_set
        ServicesAttachable.create_shell_object(self, "html")
        ServicesAttachable.create_shell_object(self, "js")
        ServicesAttachable.create_shell_object(self, "css")
        ServicesAttachable.create_shell_object(self, "config")
        true
    end

    def can_ready_to_publish?
        if self.html.present? and
           self.css.present? and
           self.js.present? and
           self.config.present? and
           self.description.present?
                return true
        end
        return false
    end

    def can_make_public?
       self.status == "Published" ? true : false
    end

end
