# == Schema Information
#
# Table name: stream_entities
#
#  id           :integer          not null, primary key
#  stream_id    :integer
#  entity_type  :string(255)
#  entity_value :string(255)
#  is_excluded  :boolean
#  created_by   :integer
#  updated_by   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class StreamEntity < ApplicationRecord
    #CONSTANTS
    #CUSTOM TABLES
    #GEMS
    #ASSOCIATIONS
    belongs_to :stream
    #ACCESSORS
    #VALIDATIONS
    validates :entity_type, presence: true
    validates :entity_value, presence: true, uniqueness: {scope: [:entity_type, :stream_id]}
    #CALLBACKS
    before_save :before_save_set
    before_destroy :before_destroy_set
    #SCOPE
    scope :folders, -> {where(entity_type: "folder_id")}
    scope :template_cards, -> {where(entity_type: "template_card_id")}
    #OTHER

    #PRIVATE
    private

    def before_destroy_set
        self.stream.update_card_count
    end

    def before_save_set
        self.is_excluded = true if self.entity_type == "blacklist"
    end
end