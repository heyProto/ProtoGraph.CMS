# == Schema Information
#
# Table name: colour_swatches
#
#  id          :bigint(8)        not null, primary key
#  red         :bigint(8)
#  green       :bigint(8)
#  blue        :bigint(8)
#  image_id    :bigint(8)
#  is_dominant :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  name        :string(255)
#

class ColourSwatch < ApplicationRecord
    #CONSTANTS
    #CUSTOM TABLES
    #GEMS
    #CONCERNS
    #ASSOCIATIONS
    belongs_to :image
    #ACCESSORS
    #VALIDATIONS
    #CALLBACKS
    #SCOPE
    scope :dominant, -> {where(is_dominant: true)}
    scope :palette, -> {where.not(is_dominant: true)}
    #OTHER
    #PRIVATE
end
