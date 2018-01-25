# == Schema Information
#
# Table name: image_variations
#
#  id               :integer          not null, primary key
#  image_id         :integer
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
#  mode             :string(255)
#  is_social_image  :boolean
#  is_smart_cropped :boolean          default(FALSE)
#

class ImageVariation < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  belongs_to :image
  delegate :account, to: :image
  #ACCESSORS
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  #VALIDATIONS
  #CALLBACKS
  after_create :process_and_upload_image, if: :is_original?
  after_create :process_and_upload_image_variation, if: :not_is_original?
  after_commit :process_and_upload_smart_cropped_variation, if: :is_smart_cropped?, on: [:create]
  #SCOPE
  #OTHER
  #PRIVATE

  def image_url
    "#{account.cdn_endpoint}/#{image_key}"
  end

  def as_json
    {
      id: self.id,
      image_url: self.image_url,
      image_key: self.image_key,
      image_width: self.image_width,
      image_height: self.image_height,
      aspectWidth: self.image_width / self.image_width.gcd(self.image_height),
      aspectHeight: self.image_height / self.image_width.gcd(self.image_height),
      is_smart_cropped: is_smart_cropped
    }
  end

  private


  def not_is_original?
    not self.is_original?
  end

  def process_and_upload_smart_cropped_variation
    data = {
      imageVariationId: id,
      s3Identifier: image.s3_identifier,
      accountSlug: account.slug,
      originalImageLink: image.original_image.image_url
    }

    url = "#{AWS_API_DATACAST_URL}/images/smartcrop"
    response = RestClient.post(url, data.to_json, {
      content_type: :json,
      accept: :json,
      "x-api-key" => ENV['AWS_API_KEY']
    })

    response = JSON.parse(response);

    if response["success"]
      self.update_columns(
        {
          image_key: response["data"]["image_key"],
          image_height: response["data"]["image_height"],
          image_width: response["data"]["image_width"]
        }
      )
    end
  end

  def process_and_upload_image
    require "base64"
    image = self.image

    og_thumbnail_url = image.image.thumb.url
    og_image_url = image.image.url

    thumb_img_path = CGI.unescape "#{Rails.root.to_s}/public#{og_thumbnail_url}"
    img_path = CGI.unescape "#{Rails.root.to_s}/public#{og_image_url}"

    thumb_img = Magick::Image.ping(thumb_img_path).first
    img = Magick::Image.ping(img_path).first

    thumb_img_h = thumb_img.rows
    thumb_img_w = thumb_img.columns

    img_h = img.rows
    img_w = img.columns

    data = {
      id: id,
      s3Identifier: image.s3_identifier,
      accountSlug: account.slug,
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

  def process_and_upload_image_variation
    return true if (self.is_social_image or self.is_smart_cropped)
    require "base64"

    temp_new_image = Image.new({crop_x: self.crop_x, crop_y: self.crop_y, crop_w: self.crop_w, crop_h: self.crop_h})

    temp_new_image.remote_image_url = image.original_image.image_url
    temp_new_image.image.crop

    thumb_img_h = temp_new_image.image.thumb.height
    thumb_img_w = temp_new_image.image.thumb.width

    img_h = temp_new_image.image.height
    img_w = temp_new_image.image.width

    img_path = "#{Rails.root.to_s}/public#{temp_new_image.image.url}"

    data = {
      id: id,
      s3Identifier: image.s3_identifier,
      accountSlug: account.slug,
      contentType: image.image.content_type,
      imageBlob: Base64.encode64(File.open(img_path, "rb").read())
    }

    url = "#{AWS_API_DATACAST_URL}/images"
    response = RestClient.post(url, data.to_json, {
      content_type: :json,
      accept: :json,
      "x-api-key" => ENV['AWS_API_KEY']
    })

    response = JSON.parse(response);

    if response["success"]
      self.update_attributes({
        image_key: response['data']['image_key'],
        image_width: img_w,
        image_height: img_h
      })
    end
  end

end
