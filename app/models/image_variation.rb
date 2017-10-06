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
#

class ImageVariation < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  belongs_to :image
  delegate :account, to: :image
  #ACCESSORS
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :article_id
  #VALIDATIONS
  #CALLBACKS
  after_create :process_and_upload_image, if: :is_original?
  after_create :process_and_upload_image_variation, if: :not_is_original?
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
      aspectHeight: self.image_height / self.image_width.gcd(self.image_height)
    }
  end

  private


  def not_is_original?
    not self.is_original?
  end

  def process_and_upload_image
    require "base64"
    image = self.image

    og_thumbnail_url = image.image.thumb.url
    og_image_url = image.image.url

    thumb_img_path = "#{Rails.root.to_s}/public#{og_thumbnail_url}"
    img_path = "#{Rails.root.to_s}/public#{og_image_url}"

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
    return true if self.is_social_image
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

    if self.mode.present? and self.article_id.present?
      article = Article.friendly.find(self.article_id)
      if self.mode == "facebook"
        article.update_column(:facebook_uploading, true)
      elsif self.mode == "twitter"
        article.update_column(:twitter_uploading, true)
      else
        article.update_column(:instagram_uploading, true)
      end
      #Creating
      key = "images/#{self.account.slug}/#{self.image.s3_identifier}/#{self.id + 1}.png"
      a = ImageVariation.new({
        image_id: self.image_id,
        image_key: key,
        image_width: self.image_width,
        image_height: self.image_height,
        is_social_image: true,
        mode: self.mode
      })
      a.save
      Thread.new do
        data_json = {
          "data": {
            "cover_data": {
              "cover_title": "#{article.genre}",
              "logo_image": {
                "image": "#{article.account.logo_image.original_image.image_url}"
              }
            }
          }
        }

        data_json["data".to_sym]["cover_data".to_sym]["#{(self.mode == "facebook"  or self.mode == "twitter") ? "fb_image" : "instagram_image" }"] = {
          "image": "#{self.image_url}"
        }

        payload = {}
        payload["js"] = "https://cdn.protograph.pykih.com/Assets/toSocial/card.min.js?no-cache=true"
        payload["css"] = "https://cdn.protograph.pykih.com/Assets/toSocial/card.min.css?no-cache=true"
        payload["data_url"] = data_json.to_json
        payload["schema_json"] = ""
        payload["configuration_url"] = ""
        payload["configuration_schema"] = ""
        payload["initializer"] = "ProtoGraph.Card.toSocial"
        payload["key"] = key
        payload["mode"] = self.mode

        response = Api::ProtoGraph::ViewCast.render_screenshot(payload)
        if response['message'].present? and response['message'] == "Data Added Successfully"
          if self.mode == "facebook"
            article.update_columns(og_image_variation_id: a.id, facebook_uploading: false)

          elsif self.mode == "twitter"
            article.update_columns(twitter_image_variation_id: a.id, twitter_uploading: false)
          else
            article.update_columns(instagram_image_variation_id: a.id, instagram_uploading: false)
          end

        end
        ActiveRecord::Base.connection.close
      end
    end

  end

end
