# == Schema Information
#
# Table name: audio_variations
#
#  id                 :integer          not null, primary key
#  account_id         :integer
#  audio_id           :string(255)
#  integer            :string(255)
#  start_time         :integer
#  end_time           :integer
#  is_original        :boolean
#  total_time         :integer
#  subtitle_file_path :string(255)
#  created_by         :integer
#  updated_by         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class AudioVariation < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  belongs_to :account
  belongs_to :audio
  #ACCESSORS
  #VALIDATIONS
  #CALLBACKS
  #SCOPE
  #OTHER
  #PRIVATE
end
