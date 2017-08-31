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
    require 'csv'
    errors = []
    # The last jq filter returns an array of json objects
    card_array_filtered = %x(csv2json #{self.attachment.file.file} | jq -f jq_filter.jq | jq -s '.')
    card_array_filtered = JSON.parse(card_array_filtered)
    schema = JSON.parse(RestClient.get(self.template_card.template_datum.schema_json))
    # url = "#{AWS_API_DATACAST_URL}/pub/validate-json"
    card_array_filtered.each do |card_filtered|
      error = JSON::Validator.fully_validate(schema, card_filtered)
      if error.empty?
        CardUploadWorker.perform_async(self.id, card_filtered, "name", "seo_blockquote_text", "source")
      end
      errors << error
    end
    self.validation_errors = errors.to_json.to_s
    self.upload_errors = "[]"
    self.save
  end
  #PRIVATE
end

