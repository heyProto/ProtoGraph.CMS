# == Schema Information
#
# Table name: uploads
#
#  id               :integer          not null, primary key
#  attachment       :string(255)
#  template_card_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Upload < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  belongs_to :template_card
  #ACCESSORS
  mount_uploader :attachment, CsvUploader
  #VALIDATIONS
  #CALLBACKS
  #SCOPE
  #OTHER
  #PRIVATE
end
