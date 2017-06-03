# == Schema Information
#
# Table name: template_streams
#
#  id                 :integer          not null, primary key
#  account_id         :integer
#  name               :string(255)
#  description        :text(65535)
#  slug               :string(255)
#  version            :float(24)
#  is_current_version :boolean
#  status             :string(255)
#  publish_count      :integer
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
    has_many :template_stream_cards
    has_many :template_cards, through: :template_stream_cards
    has_one :html, as: :attachable, ->{where(genre: "html")}
    has_one :css, as: :attachable, ->{where(genre: "css")}
    has_one :js, as: :attachable, ->{where(genre: "js")}
    has_one :config, as: :attachable, ->{where(genre: "config")}

    #ACCESSORS
    #VALIDATIONS
    validates :account_id, presence: true
    validates :name, presence: true
    validates :version, presence: true
    validates :created_by, presence: true
    validates :updated_by, presence: true

    #CALLBACKS
    before_create :before_create_set
    after_create :after_create_set

    #SCOPE
    #OTHER
    #PRIVATE
    private

    def slug_candidates
        ["#{self.name}-#{self.version}"]
    end

    def should_generate_new_friendly_id?
        slug.blank? || version_changed?
    end

    def before_create_set
        self.publish_count = 0
        self.is_current_version = false if self.is_current_version.blank?
        self.is_public = false if self.is_public.blank?
        self.status = "Draft"
        true
    end

    def after_create_set
        ServicesAttachable.create(attachable_id: self.id, attachable_type: "TemplateStream", genre: "html", account_id: self.account_id, created_by: self.created_by, updated_by: self.updated_by)
        ServicesAttachable.create(attachable_id: self.id, attachable_type: "TemplateStream", genre: "js", account_id: self.account_id, created_by: self.created_by, updated_by: self.updated_by)
        ServicesAttachable.create(attachable_id: self.id, attachable_type: "TemplateStream", genre: "css", account_id: self.account_id, created_by: self.created_by, updated_by: self.updated_by)
        ServicesAttachable.create(attachable_id: self.id, attachable_type: "TemplateStream", genre: "config", account_id: self.account_id, created_by: self.created_by, updated_by: self.updated_by)
        true
    end

end
