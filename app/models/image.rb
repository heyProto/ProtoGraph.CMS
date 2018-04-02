# == Schema Information
#
# Table name: images
#
#  id               :integer          not null, primary key
#  account_id       :integer
#  name             :string(255)
#  description      :text(65535)
#  s3_identifier    :string(255)
#  thumbnail_url    :text(65535)
#  thumbnail_key    :text(65535)
#  thumbnail_width  :integer
#  thumbnail_height :integer
#  image_width      :integer
#  image_height     :integer
#  image            :string(255)
#  created_by       :integer
#  updated_by       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  is_logo          :boolean          default(FALSE)
#  is_favicon       :boolean          default(FALSE)
#  is_cover         :boolean
#

class Image < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  paginates_per 100
  #CONCERNS
  include Propagatable
  include AssociableByAc

  #ASSOCIATIONS
  has_many :image_variation, -> {where.not(is_original: true)}, dependent: :destroy
  has_one :original_image, -> {where(is_original: true)}, class_name: "ImageVariation", foreign_key: "image_id", dependent: :destroy
  has_many :activities
  has_many :colour_swatches, dependent: :destroy
  #ACCESSORS
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :image_w, :image_h
  mount_uploader :image, ImageUploader
  attr_accessor :dominant_colour
  attr_accessor :colour_palette
  #VALIDATIONS
  validate :check_dimensions_for_logo, :on => :create, if: :is_logo?
  validate :check_dimensions_for_favicon, :on => :create, if: :is_favicon?
  #CALLBACKS
  before_create { self.s3_identifier = SecureRandom.hex(8) }
  after_create :create_image_version

  # after_commit :add_colour_swatches, on: :create
  #SCOPE
  #OTHER

  def check_dimensions_for_logo
    if !image_cache.nil? and image.height < 50
      errors.add :image, "The minimum height of the logo should be 50."
    end
  end

  def check_dimensions_for_favicon
    if !image_cache.nil? and image.height < 100 and (image.height / image.width != 1)
      errors.add :image, "Favicon can be square and the maximum height should be 100."
    end
  end

  def as_json(options = {})
    {
      id: self.id,
      redirect_to: Rails.application.routes.url_helpers.account_image_path(self.account, self, folder_id: options[:folder_id]),
      thumbnail_url: self.thumbnail_url,
      thumbnail_width: self.thumbnail_width,
      thumbnail_height: self.thumbnail_height,
      image_url: self.image_url,
      image_height: self.image_height,
      image_width: self.image_width,
      aspectWidth: self.image_width / self.image_width.gcd(self.image_height),
      aspectHeight: self.image_height / self.image_width.gcd(self.image_height)
    }
  end

  def image_url
    self.original_image.image_url
  end

  # def add_colour_swatches
  #     require "ntc"
  #     unless (self.colour_palette.nil? and self.dominant_colour.nil?) or (self.colour_palette.blank? or self.dominant_colour.blank?)
  #         colour_dom = JSON.parse(self.dominant_colour)
  #         colour_pal = JSON.parse(self.colour_palette)

  #         # Dominant colour name
  #         colour_hex = colour_dom.map{|a| a.to_s(16) }.join("")
  #         colour_name = Ntc.new(colour_hex).name[1]
  #         # Ntc gives [hex_value of closest, name of closest, true if exact match]
  #         self.colour_swatches.create(red: colour_dom[0],
  #                                     green: colour_dom[1],
  #                                     blue: colour_dom[2],
  #                                     name: colour_name,
  #                                     is_dominant: true)
  #         colour_pal.each do |colour|
  #           colour_hex = colour.map{|a| a.to_s(16) }.join("")
  #           colour_name = Ntc.new(colour_hex).name[1]
  #           self.colour_swatches.create(red: colour[0],
  #                                       green: colour[1],
  #                                       blue: colour[2],
  #                                       name: colour_name)
  #         end
  #     end
  # end

  #PRIVATE
  private

  def create_image_version
    # self.image.crop
    self.image.recreate_versions!

    options = {
      image_id: self.id,
      is_original: true,
      crop_x: crop_x.to_f,
      crop_y: crop_y.to_f,
      crop_w: crop_w.to_f,
      crop_h: crop_h.to_f,
      image_h: image_h.to_f,
      image_w: image_w.to_f
    }
    ImageVariation.create(options)
  end
end
