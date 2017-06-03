# == Schema Information
#
# Table name: template_stream_cards
#
#  id                 :integer          not null, primary key
#  account_id         :integer
#  template_card_id   :integer
#  template_stream_id :integer
#  is_mandatory       :boolean
#  position           :integer
#  created_by         :integer
#  updated_by         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class TemplateStreamCard < ApplicationRecord

    #CONSTANTS
    #CUSTOM TABLES
    #GEMS
    #ASSOCIATIONS
    belongs_to :account
    belongs_to :creator, class_name: "User", foreign_key: "created_by"
    belongs_to :updator, class_name: "User", foreign_key: "updated_by"
    belongs_to :template_card
    belongs_to :template_stream

    #ACCESSORS
    #VALIDATIONS
    validates :account_id, presence: true
    validates :template_card_id, presence: true
    validates :template_stream_id, presence: true
    validates :created_by, presence: true
    validates :updated_by, presence: true

    #CALLBACKS
    before_create :before_create_set

    #SCOPE
    #OTHER
    #PRIVATE
    private

    def before_create_set
        self.is_mandatory = false
        self.position = 0
        true
    end

end
