# == Schema Information
#
# Table name: template_data
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
#  api_key            :string(255)
#  publish_count      :integer
#  is_public          :boolean
#  created_by         :integer
#  updated_by         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class TemplateDatum < ApplicationRecord

    #CONSTANTS
    #CUSTOM TABLES
    #GEMS
    extend FriendlyId
    friendly_id :slug_candidates, use: :scoped, scope: [:account_id]

    #ASSOCIATIONS
    belongs_to :account
    belongs_to :creator, class_name: "User", foreign_key: "created_by"
    belongs_to :updator, class_name: "User", foreign_key: "updated_by"
    has_many :template_cards
    has_many :datacasts
    has_one :sample_json, ->{where(genre: "sample_json")}, as: :attachable
    has_one :xsd, ->{where(genre: "xsd")}, as: :attachable

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
        TemplateDatum.where(global_slug: self.global_slug, is_current_version: true).first
    end

    def siblings
        TemplateDatum.where(global_slug: self.global_slug)
    end

    def flip_public_private
        if self.is_public
            if self.can_make_private?
                self.update_attributes(is_public: false)
                return "Successfully done."
            else
                return "Failed. Some other account is using a card associated with this data."
            end
        else
            if self.can_make_public?
                self.update_attributes(is_public: true)
                return "Successfully done."
            else
                return "Failed. Make sure data is published."
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
            self.api_key = SecureRandom.hex(24)
            self.global_slug = self.name.gsub(" ", "-").downcase #TODO AMIT is there a better way to sluggify?
            self.is_current_version = true
        end
        true
    end

    def after_create_set
        ServicesAttachable.create_shell_object(self, "sample_json")
        ServicesAttachable.create_shell_object(self, "xsd")
        true
    end

    def can_make_public?
        self.status == "Published" ? true : false
    end

    def can_make_private?
        true
        #self.cards.where("account_id != ?", self.account_id).first.present? ? false : true
    end

    def can_ready_to_publish?
        if self.xsd.present? and self.sample_json.present?
            return true
        end
        return false
    end

end
