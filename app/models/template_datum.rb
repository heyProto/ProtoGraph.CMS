# == Schema Information
#
# Table name: template_data
#
#  id            :integer          not null, primary key
#  account_id    :integer
#  name          :string(255)
#  description   :text(65535)
#  slug          :string(255)
#  status        :string(255)
#  api_key       :string(255)
#  publish_count :integer
#  is_public     :boolean
#  created_by    :integer
#  updated_by    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
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
    has_one :sample_json, ->{where(genre: "sample_json")}, as: :attachable
    has_one :xsd, ->{where(genre: "xsd")}, as: :attachable

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
        self.api_key = SecureRandom.hex(24)
        self.is_public = false if self.is_public.blank?
        self.status = "Draft"
        true
    end

    def after_create_set
        ServicesAttachable.create_shell_object(self, "sample_json")
        ServicesAttachable.create_shell_object(self, "xsd")
        true
    end

end
