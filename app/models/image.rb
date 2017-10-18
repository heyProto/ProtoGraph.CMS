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
#

class Image < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  acts_as_taggable
  paginates_per 100
  #ASSOCIATIONS
  belongs_to :account
  has_many :image_variation, -> {where.not(is_original: true)}
  has_one :original_image, -> {where(is_original: true)}, class_name: "ImageVariation", foreign_key: "image_id"
  has_many :activities
  has_many :colour_swatches
  #ACCESSORS
  attr_accessor :tag_list, :crop_x, :crop_y, :crop_w, :crop_h
  mount_uploader :image, ImageUploader
  attr_accessor :dominant_colour
  attr_accessor :colour_palette
  #VALIDATIONS
  #CALLBACKS
  before_create { self.s3_identifier = SecureRandom.hex(8) }
  after_create :create_image_version

  validate :check_dimensions, :on => :create, if: :is_logo?
  def check_dimensions
    if !image_cache.nil? and image.height > 100 and ((image.height / image.width) == 400)
      errors.add :image, "Logo has to a square and the minimum height should be 100."
    end
  end
  after_commit :add_colour_swatches, on: :create
  #SCOPE
  #OTHER

  def as_json(options = {})
    {
      id: self.id,
      redirect_to: Rails.application.routes.url_helpers.account_image_path(self.account_id, self),
      thumbnail_url: self.thumbnail_url,
      thumbnail_width: self.thumbnail_width,
      thumbnail_height: self.thumbnail_height,
      image_url: self.original_image.image_url,
      image_height: self.image_height,
      image_width: self.image_width,
      aspectWidth: self.image_width / self.image_width.gcd(self.image_height),
      aspectHeight: self.image_height / self.image_width.gcd(self.image_height)
    }
  end

  def image_url
    self.original_image.image_url
  end

  def add_colour_swatches
      unless (self.colour_palette.nil? and self.dominant_colour.nil?) or (self.colour_palette.blank? or self.dominant_colour.blank?)
          colour_dom = JSON.parse(self.dominant_colour)
          colour_pal = JSON.parse(self.colour_palette)
          self.colour_swatches.create(red: colour_dom[0],
                                      green: colour_dom[1],
                                      blue: colour_dom[2],
                                      is_dominant: true)
          colour_pal.each do |colour|
            self.colour_swatches.create(red: colour[0],
                                        green: colour[1],
                                        blue: colour[2])
          end
      end
  end

  #PRIVATE
  private

  def create_image_version
    self.image.crop
    self.image.recreate_versions!

    options = {
      image_id: self.id,
      is_original: true
    }

    ImageVariation.create(options)
  end
end
