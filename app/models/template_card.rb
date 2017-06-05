# == Schema Information
#
# Table name: template_cards
#
#  id                  :integer          not null, primary key
#  account_id          :integer
#  template_datum_id   :integer
#  name                :string(255)
#  description         :text(65535)
#  slug                :string(255)
#  global_slug         :string(255)
#  version             :float(24)
#  previous_version_id :integer
#  status              :string(255)
#  publish_count       :integer
#  is_public           :boolean
#  created_by          :integer
#  updated_by          :integer
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
    has_one :html, ->{where(genre: "html")}, as: :attachable
    has_one :css, ->{where(genre: "css")}, as: :attachable
    has_one :js, ->{where(genre: "js")}, as: :attachable
    has_one :config, ->{where(genre: "config")}, as: :attachable
    has_many :images, ->{where(genre: "images")}, as: :attachable


    #ACCESSORS
    #VALIDATIONS
    validates :account_id, presence: true
    validates :template_datum_id, presence: true
    validates :name, presence: true, uniqueness: {scope: :account, case_sensitive: false }
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


    #PRIVATE
    private

    def should_generate_new_friendly_id?
        slug.blank? || name_changed?
    end

    def before_create_set
        self.publish_count = 0
        self.version = 0.1
        self.is_public = false if self.is_public.blank?
        self.status = "Draft"
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
