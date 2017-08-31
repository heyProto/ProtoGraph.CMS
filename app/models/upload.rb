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
  validates :attachment, presence: true
  #CALLBACKS
  after_create :validate_csv
  #SCOPE
  #OTHER
  def validate_csv
    schema = JSON.parse(RestClient.get(self.template_card.template_datum.schema_json))
    File.open(self.attachment.file, "r") do |f|
      CSV.foreach(f, headers: true) do |row|
        row.to_hash
      end
    end
  end
  #PRIVATE
end

File.open(Upload.first.attachment.file.file, "r") do |f|
  CSV.foreach(f, headers: true) do |row|
    puts row.to_hash.to_json
  end
end
