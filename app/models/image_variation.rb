# == Schema Information
#
# Table name: image_variations
#
#  id               :integer          not null, primary key
#  image_id         :integer
#  image_url        :text(65535)
#  image_key        :text(65535)
#  image_width      :integer
#  image_height     :integer
#  thumbnail_url    :text(65535)
#  thumbnail_key    :text(65535)
#  thumbnail_width  :integer
#  thumbnail_height :integer
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
  belongs_to :image
  #ACCESSORS
  #VALIDATIONS
  #CALLBACKS
  after_create :process_and_upload_image
  #SCOPE
  #OTHER
  #PRIVATE
  private

  def process_and_upload_image
    require "base64"
    image = self.image

    og_thumbnail_url = image.image.thumb.url
    og_image_url = image.image.url

    thumb_img_path = "#{Rails.root.to_s}/public/#{og_thumbnail_url}"
    img_path = "#{Rails.root.to_s}/public/#{og_image_url}"

    thumb_img = Magick::Image.ping(thumb_img_path).first
    img = Magick::Image.ping(img_path).first

    thumb_img_h = thumb_img.rows
    thumb_img_w = thumb_img.columns

    img_h = img.rows
    img_w = img.columns

    data = {
      id: id,
      s3Identifier: image.s3_identifier,
      accountSlug: image.account.slug,
      contentType: image.image.content_type,
      imageBlob: Base64.encode64(File.open(img_path, "rb").read()),
      thumbnailBlob: Base64.encode64(File.open(thumb_img_path, "rb").read())
    }

    url = "#{AWS_API_DATACAST_URL}/images"
    response = RestClient.post(url, data.to_json, {
      content_type: :json,
      accept: :json,
      "x-api-key" => ENV['AWS_API_KEY']
    })

    response = JSON.parse(response);

    if response["success"]
      image.update_attributes({
        thumbnail_url: response['data']['thumbnail_url'],
        thumbnail_key: response['data']['thumbnail_key'],
        image_width: img_w,
        image_height: img_h,
        thumbnail_width: thumb_img_w,
        thumbnail_height: thumb_img_h
      })

      self.update_attributes({
        image_url: response['data']['image_url'],
        image_key: response['data']['image_key'],
        image_width: img_w,
        image_height: img_h,
        thumbnail_url: response['data']['thumbnail_url'],
        thumbnail_key: response['data']['thumbnail_key'],
        thumbnail_width: thumb_img_w,
        thumbnail_height: thumb_img_h
      })
    end

  end

end
