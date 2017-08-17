# == Schema Information
#
# Table name: images
#
#  id               :integer          not null, primary key
#  account_id       :integer
#  name             :string(255)
#  description      :text(65535)
#  s3_identifer     :string(255)
#  thumbnail_url    :text(65535)
#  thumbnail_width  :integer
#  thumbnail_height :integer
#  image            :string(255)
#  created_by       :integer
#  updated_by       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Image < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  #ACCESSORS
  attr_accessor :tags
  mount_uploader :image, ImageUploader
  #VALIDATIONS
  #CALLBACKS
  before_create :create_image_version

  #SCOPE
  #OTHER
  #PRIVATE
  private

  def create_image_version
    self.image.recreate_versions!
    self.thumbnail_url = image.thumb.url
    img = Magick::Image.ping("#{Rails.root.to_s}/public/#{self.thumbnail_url}").first
    self.thumbnail_width = img.columns
    self.thumbnail_height = img.rows
    # asdads
    # image_json = image.as_json
    # ImageVariation.create_and_upload_variation({
    #   image_id: self.id,
    #   is_original: true,
    #   image_url: image_json['url'],
    #   thumbnail_url: image_json['thumb']
    # })
    true
  end
end
