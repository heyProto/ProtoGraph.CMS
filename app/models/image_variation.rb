# == Schema Information
#
# Table name: image_variations
#
#  id               :integer          not null, primary key
#  image_id         :integer
#  image_url        :text(65535)
#  image_width      :integer
#  image_height     :integer
#  thumbnail_url    :text(65535)
#  thumbnail_width  :integer
#  thumbnail_height :integer
#  key              :text(65535)
#  is_original      :boolean
#  created_by       :integer
#  updated_by       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class ImageVariation < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  #ACCESSORS
  attr_accessor :tags, :og_image_url,
  # mount_uploader :image, ImageUploader
  #VALIDATIONS
  #CALLBACKS
  # after_create :upload_image_to_s3

  #SCOPE
  #OTHER
  class << self
    def create_and_upload_variation

    end
  end
  #PRIVATE
  private

  def create_image_version
    # self.image.recreate_versions!
    # self.thumbnail_url = image.thumb.url
    # img = Magick::Image.ping("#{Rails.root.to_s}/public/#{self.thumbnail_url}").first
    # self.thumbnail_width = img.columns
    # self.thumbnail_height = img.rows
    # image_variation = ImageVariation.new({
    #   image_id: self.id,
    #   is_original: true
    #   });
    true
  end
end
