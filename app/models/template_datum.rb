# == Schema Information
#
# Table name: template_data
#
#  id                 :integer          not null, primary key
#  account_id         :integer
#  name               :string(255)
#  description        :text(65535)
#  slug               :string(255)
#  version            :float(24)
#  is_current_version :boolean
#  status             :string(255)
#  api_key            :string(255)
#  publish_count      :integer
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
    has_one :sample_json, as: :attachable, ->{where(genre: "sample_json")}
    has_one :xsd, as: :attachable, ->{where(genre: "xsd")}

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
        slug.blank? ||  name_changed?
    end

    def before_create_set
        self.publish_count = 0
        self.api_key = SecureRandom.hex(24)
        self.is_current_version = false if self.is_current_version.blank?
        self.is_public = false if self.is_public.blank?
        self.status = "Draft"
        true
    end

    def after_create_set
        ServicesAttachable.create(attachable_id: self.id, attachable_type: "TemplateStream", genre: "sample_json", account_id: self.account_id, created_by: self.created_by, updated_by: self.updated_by)
        ServicesAttachable.create(attachable_id: self.id, attachable_type: "TemplateStream", genre: "xsd", account_id: self.account_id, created_by: self.created_by, updated_by: self.updated_by)
        true
    end

end