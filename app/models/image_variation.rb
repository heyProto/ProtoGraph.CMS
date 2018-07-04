# == Schema Information
#
# Table name: image_variations
#
#  id               :integer          not null, primary key
#  image_id         :integer
#  image_key        :text
#  image_width      :integer
#  image_height     :integer
#  thumbnail_url    :text
#  thumbnail_key    :text
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
#  site_id          :integer
#

class ImageVariation < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #CONCERNS
  include Propagatable
  include AssociableBySi
  #ASSOCIATIONS
  belongs_to :image
  delegate :site, to: :image

  #ACCESSORS
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :resize, :autocreate, :image_w, :image_h, :instant_output
  #VALIDATIONS
  #CALLBACKS
  # after_create :process_and_upload_image, if: :is_original?
  # after_create :process_and_upload_image_variation, if: :not_is_original?
  # after_commit :process_and_upload_smart_cropped_variation, if: :is_smart_cropped?, on: [:create]
  after_create :process_image, if: :not_autocreate?
  #SCOPE
  #OTHER
  #PRIVATE

  def image_url
    puts "site=#{self.id}, #{site}"
    "#{site.cdn_endpoint}/#{image_key}"
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

  def upload_image
    require "base64"
    require 'rest-client'
    image = self.image

    if self.is_original
      og_image_url = image.image.url
      img_path = CGI.unescape "#{Rails.root.to_s}/public#{og_image_url}"
      image_blob = Base64.encode64(File.open(img_path, "rb").read())
    else
      img_path = "#{self.site.cdn_endpoint}/#{self.image.original_image.image_key}"
      res = RestClient.get(img_path)
      image_blob = Base64.encode64(res.to_s)
    end

    data = {
      image_blob: image_blob,
      options: {
        image_type: image.image.content_type.split("/").last,
        content_type: image.image.content_type,
        compression_type: "Lossless",
        site_slug: site.slug,
        s3_identifier: image.s3_identifier,
        image_id: id
      },
      bucket_name: site.cdn_bucket
    }

    if image_w > 0 and image_h > 0
      data[:options][:image_w] = image_w
      data[:options][:image_h] = image_h
    end

    if crop_w > 0 and crop_h > 0
      data[:options][:crop] = {
        x: crop_x,
        y: crop_y,
        width: crop_w,
        height: crop_h
      }
    end

    url = "#{AWS_API_DATACAST_URL}/v3-images"
    response = RestClient.post(url, data.to_json, {
      content_type: :json,
      accept: :json,
      "x-api-key" => ENV['AWS_API_KEY']
    })

    response = JSON.parse(response);
    if response["success"]
      data = response["data"]
      og_image = data.select { |i| i["mode"] === "og" }[0]
      thumbnail = data.select { |i| i["mode"] === "thumb" }[0]
      other_modes = data.select { |i| not ["og", "thumb"].index(i["mode"]).present? }
      if self.is_original
        image.update_attributes({
          thumbnail_url: thumbnail["data"]["Location"],
          thumbnail_key: thumbnail["data"]["key"],
          image_width: og_image["width"],
          image_height: og_image["height"],
          thumbnail_width: thumbnail["width"],
          thumbnail_height: thumbnail["height"]
        })
      end

      a = self.update_attributes({
        image_key: og_image["data"]["key"],
        image_width: og_image["width"],
        image_height: og_image["height"],
        thumbnail_url: thumbnail["data"]["Location"],
        thumbnail_key: thumbnail["data"]["key"],
        thumbnail_width: thumbnail["width"],
        thumbnail_height: thumbnail["height"],
        mode: "original"
      })

      other_modes.each do |img|
        ImageVariation.create({
          image_id: self.image_id,
          image_key: img["data"]["key"],
          image_width: img["width"],
          image_height: img["height"],
          thumbnail_url: thumbnail["data"]["Location"],
          thumbnail_key: thumbnail["data"]["key"],
          thumbnail_width: thumbnail["width"],
          thumbnail_height: thumbnail["height"],
          mode: img["mode"],
          autocreate: true,
          is_original: false
        })
      end

      FileUtils.rm_rf(img_path)
    else
      if self.is_original
        if self.image.is_cover
          page = Page.where(cover_image_id_7_column: self.image.original_image.id)
          page.update_columns({
            cover_image_id_7_column: nil,
            cover_image_id_4_column: nil,
            cover_image_id_3_column: nil,
            cover_image_id_2_column: nil
          })
        end
        self.image.destroy
      else
        self.destroy
      end
    end
    true
  end

  private

  def not_is_original?
    not self.is_original?
  end

  def not_autocreate?
    not self.autocreate
  end

  def process_image
    unless self.instant_output === "true"
      ImageWorker.perform_in(2.seconds.from_now, self.id, crop_x, crop_y, crop_w, crop_h, resize, autocreate, image_w, image_h)
    else
      self.upload_image
    end
  end

end
