# == Schema Information
#
# Table name: colour_swatches
#
#  id          :integer          not null, primary key
#  red         :integer
#  green       :integer
#  blue        :integer
#  image_id    :integer
#  is_dominant :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  name        :string(255)
#

class ColourSwatch < ApplicationRecord
    #CONSTANTS
    #CUSTOM TABLES
    #GEMS
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
