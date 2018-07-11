# == Schema Information
#
# Table name: uploads
#
#  id               :integer          not null, primary key
#  attachment       :string(255)
#  template_card_id :decimal(, )
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  folder_id        :decimal(, )
#  created_by       :integer
#  updated_by       :integer
#  upload_errors    :text
#  filtering_errors :text
#  upload_status    :string(255)
#  total_rows       :integer
#  rows_uploaded    :integer
#  site_id          :integer
#

class Upload < ApplicationRecord
  #CONSTANTS
  UPLOAD_STATUSES = ["waiting", "uploading", "failed", "completed"]
  #CUSTOM TABLES
  #GEMS
  #CONCERNS
  include AssociableBySiFo
  #ASSOCIATIONS
  belongs_to :template_card

  #ACCESSORS
  mount_uploader :attachment, CsvUploader
  
  #VALIDATIONS
  validates :attachment, presence: true
  validates :folder, presence: true
  validates :upload_status, inclusion: { in: Upload::UPLOAD_STATUSES }
  
  #CALLBACKS
  after_commit :validate_csv, on: :create
  
  #SCOPE
  #OTHER
  def validate_csv
    CsvVerificationWorker.perform_async(self.id)
  end

  def validate_headers
    require 'csv'
    csv_headers = CSV.read(self.attachment.file.file)[0]
    path = Rails.root.join("public/csv_templates/#{self.template_card.name.underscore}.csv")
    template_card_headers = CSV.read(path)[0]
    return csv_headers == template_card_headers
  end
  #PRIVATE
end

