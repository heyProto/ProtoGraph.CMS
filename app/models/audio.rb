# == Schema Information
#
# Table name: audios
#
#  id            :integer          not null, primary key
#  account_id    :integer
#  name          :string(255)
#  description   :text(65535)
#  s3_identifier :string(255)
#  total_time    :integer
#  created_by    :string(255)
#  updated_by    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Audio < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  acts_as_taggable
  #ASSOCIATIONS
  belongs_to :account
  has_many :audio_variations
  has_one :original_audio, -> {where(is_original: true)}, class_name: "AudioVariation", foreign_key: "audio_id"
  has_many :activities
  #ACCESSORS
  #VALIDATIONS
  #CALLBACKS
  before_create { self.s3_identifier = SecureRandom.hex(8) }
  after_create :create_audio_version
  #SCOPE
  #OTHER
  #PRIVATE
end
