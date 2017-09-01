# == Schema Information
#
# Table name: uploads
#
#  id                :integer          not null, primary key
#  attachment        :string(255)
#  template_card_id  :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  validation_errors :text(65535)
#  account_id        :integer
#  folder_id         :integer
#  created_by        :integer
#  updated_by        :integer
#  upload_errors     :text(65535)
#

class Upload < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  belongs_to :template_card
  belongs_to :folder
  include Associable
  #ACCESSORS
  attr_accessor :account_id, :folder_id, :user_id
  mount_uploader :attachment, CsvUploader
  #VALIDATIONS
  validates :attachment, presence: true
  validates :folder, presence: true
  #CALLBACKS
  after_create :validate_csv
  #SCOPE
  #OTHER
  def validate_csv
    CsvVerificationWorker.perform_async(self.id)
  end
  #PRIVATE
end

