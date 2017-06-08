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
#  created_by          :integer
#  updated_by          :integer
#  template_datum_id   :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class TemplateCard < ApplicationRecord

    #CONSTANTS
    STATUS = ["Draft", "Ready to Publish", "Published", "Deactivated"]

    #CUSTOM TABLES
    #GEMS
    extend FriendlyId
    friendly_id :slug_candidates, use: :scoped, scope: [:account_id]

    #ASSOCIATIONS
    belongs_to :account
    belongs_to :creator, class_name: "User", foreign_key: "created_by"
    belongs_to :updator, class_name: "User", foreign_key: "updated_by"
    belongs_to :template_datum
    has_many :template_stream_cards, dependent: :destroy
    has_many :template_streams, through: :template_stream_cards
    has_one :html, ->{where(genre: "html", attachable_type: "TemplateCard")}, class_name: "ServicesAttachable", foreign_key: "attachable_id"
    has_one :css, ->{where(genre: "css", attachable_type: "TemplateCard")}, class_name: "ServicesAttachable", foreign_key: "attachable_id"
    has_one :js, ->{where(genre: "js", attachable_type: "TemplateCard")}, class_name: "ServicesAttachable", foreign_key: "attachable_id"
    has_one :config, ->{where(genre: "config", attachable_type: "TemplateCard")}, class_name: "ServicesAttachable", foreign_key: "attachable_id"
    has_many :images, ->{where(genre: "images", attachable_type: "TemplateCard")}, class_name: "ServicesAttachable", foreign_key: "attachable_id"


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

    def parent
        TemplateCard.where(global_slug: self.global_slug, is_current_version: true).first
    end

    def previous
       TemplateCard.where(global_slug: self.global_slug, id: self.previous_version_id).first
    end

    def siblings
        TemplateCard.where(global_slug: self.global_slug)
    end

    def flip_public_private
        if self.is_public
            if self.can_make_private?
                self.update_attributes(is_public: false)
                return "Successfully done."
            else
                return "Failed. Some other account is using this card."
            end
        else
            if self.can_make_public?
                self.update_attributes(is_public: true)
                return "Successfully done."
            else
                return "Failed. Make sure card is published and associated data is public."
            end
        end
    end

    def move_to_next_status
        if self.can_ready_to_publish?
            self.update_attributes(status: "Ready to Publish")
            return "Successfully updated."
        elsif self.status == "Ready to Publish"
            self.update_attributes(status: "Published")
            return "Successfully updated."
        else
            return "Failed"
        end
    end

    def deep_copy
        self.account_id = self.previous.account_id
        self.name = self.previous.name
        self.global_slug = self.previous.global_slug
        self.is_current_version = false
        self.is_public = self.previous.is_public
        self.version_series = self.version_genre != "major" ? self.previous.version_series + 1 : self.previous.version_series
        self.description = self.previous.description
        self.elevator_pitch = self.previous.elevator_pitch
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
            self.global_slug = self.name.gsub(" ", "-").downcase #TODO AMIT is there a better way to sluggify?
            self.is_current_version = true
            self.version_series = "0"
            self.previous_version_id = nil
            self.version_genre = "major"
            self.version = "0.1.0"
            self.is_public = false
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

    def can_make_private?
        self.cards.where("account_id != ?", self.account_id).first.present? ? false : true
    end

    def can_make_public?
        (self.status == "Published" and self.template_datum.is_public) ? true : false
    end

    def can_ready_to_publish?
        if self.template_datum.status == "Published" and
           self.html.present? and
           self.css.present? and
           self.js.present? and
           self.config.present? and
           self.description.present?
                return true
        end
        return false
    end

end
