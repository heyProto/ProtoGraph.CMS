# == Schema Information
#
# Table name: uploads
#
#  id               :integer          not null, primary key
#  attachment       :string(255)
#  template_card_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  account_id       :integer
#  folder_id        :integer
#  created_by       :integer
#  updated_by       :integer
#  upload_errors    :text(65535)
#  filtering_errors :text(65535)
#  upload_status    :string(255)      default("waiting")
#  total_rows       :integer
#  rows_uploaded    :integer
#

class Upload < ApplicationRecord
  #CONSTANTS
  UPLOAD_STATUSES = ["waiting", "uploading", "failed", "completed"]
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  belongs_to :account
  belongs_to :template_card
  belongs_to :folder
  include Associable
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

