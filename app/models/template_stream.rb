# == Schema Information
#
# Table name: template_streams
#
#  id            :integer          not null, primary key
#  account_id    :integer
#  name          :string(255)
#  description   :text(65535)
#  slug          :string(255)
#  status        :string(255)
#  publish_count :integer
#  is_public     :boolean
#  created_by    :integer
#  updated_by    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
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
    has_one :html, ->{where(genre: "html")}, as: :attachable
    has_one :css, ->{where(genre: "css")}, as: :attachable
    has_one :js, ->{where(genre: "js")}, as: :attachable
    has_one :config, ->{where(genre: "config")}, as: :attachable

    #ACCESSORS
    #VALIDATIONS
    validates :account_id, presence: true
    validates :name, presence: true, uniqueness: {scope: :account, case_sensitive: false }
    validates :created_by, presence: true
    validates :updated_by, presence: true

    #CALLBACKS
    before_create :before_create_set
    after_create :after_create_set

    #SCOPE
    #OTHER
    def slug_candidates
        ["#{self.name}-#{self.version}"]
    end

    def version
        0.1
    end

    #PRIVATE
    private

    def should_generate_new_friendly_id?
        slug.blank? || name_changed?
    end

    def before_create_set
        self.publish_count = 0
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
