# == Schema Information
#
# Table name: pages
#
#  id                               :integer          not null, primary key
#  account_id                       :integer
#  site_id                          :integer
#  folder_id                        :integer
#  headline                         :string(255)
#  meta_tags                        :string(255)
#  meta_description                 :text(65535)
#  summary                          :text(65535)
#  layout                           :string(255)
#  byline                           :string(255)
#  byline_stream                    :string(255)
#  cover_image_url                  :text(65535)
#  cover_image_url_7_column         :text(65535)
#  cover_image_url_facebook         :text(65535)
#  cover_image_url_square           :text(65535)
#  cover_image_alignment            :string(255)
#  is_sponsored                     :boolean
#  is_interactive                   :boolean
#  has_data                         :boolean
#  has_image_other_than_cover       :boolean
#  has_audio                        :boolean
#  has_video                        :boolean
#  is_published                     :boolean
#  published_at                     :datetime
#  url                              :text(65535)
#  ref_category_series_id           :integer
#  ref_category_intersection_id     :integer
#  ref_category_sub_intersection_id :integer
#  view_cast_id                     :integer
#  page_object_url                  :text(65535)
#  created_by                       :integer
#  updated_by                       :integer
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  datacast_identifier              :string(255)
#

class Page < ApplicationRecord

  #CONSTANTS
  Datacast_ENDPOINT = "#{ENV['AWS_S3_ENDPOINT']}"
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  belongs_to :account
  belongs_to :site
  belongs_to :folder
  belongs_to :series, class_name: "RefCategory", foreign_key: :ref_category_series_id
  belongs_to :intersection, class_name: "RefCategory", foreign_key: :ref_category_intersection_id
  belongs_to :sub_intersection, class_name: "RefCategory", foreign_key: :ref_category_sub_intersection_id
  belongs_to :view_cast, optional: true
  belongs_to :creator, class_name: "User", foreign_key: "created_by"
  belongs_to :updator, class_name: "User", foreign_key: "updated_by"
  has_many :page_streams
  has_many :streams, through: :page_streams

  #ACCESSORS
  #VALIDATIONS
  validates :headline, presence: true, length: { in: 50..90 }
  validates :summary, length: { in: 100..220 }
  #CALLBACKS
  before_create :before_create_set

  before_save :before_save_set

  after_create :create_page_streams
  after_create :create_story_card
  after_create :push_json_to_s3

  after_update :create_story_card
  #SCOPE
  #OTHER
  #PRIVATE
  private

  def before_create_set
    self.datacast_identifier = SecureRandom.hex(12)   if self.datacast_identifier.blank?
    self.is_interactive = false                       if self.is_interactive.blank?
    self.has_data = false                             if self.has_data.blank?
    self.has_image_other_than_cover = false           if self.has_image_other_than_cover.blank?
    self.has_audio = false                            if self.has_audio.blank?
    self.has_video = false                            if self.has_video.blank?
    self.is_sponsored = false                         if self.is_sponsored.blank?
    self.is_published = false                         if self.is_published.blank?
    self.url = "#{Datacast_ENDPOINT}/#{self.datacast_identifier}/index.html"
    true
  end

  def before_save_set
    if self.has_data == true or self.has_image_other_than_cover == true or self.has_audio == true or self.has_video == true
      self.is_interactive = true
    end
    true
  end

  def create_page_streams
    case self.layout
    when 'section'
      streams = ["Homepage-16c-Hero", "Homepage-7c", "Homepage-4c", "Homepage-3c", "Homepage-2c"]
    when 'article'
      streams = ["Story-Narrative", "Story-Related"]
    when 'grid'
      streams = []
    else
      streams = []
    end
    streams.each do |s|
      s = Stream.create!({
        col_name: "Page",
        col_id: self.id,
        account_id: self.account_id,
        site_id: self.site_id,
        title: "#{self.id}-#{s}",
        description: "#{self.id}-#{s} stream #{self.summary}"
      })
    end
    true
  end

  def create_story_card
    if self.view_cast_id.nil? and self.is_published == true
    end
    true
  end

  def push_json_to_s3
    site = self.site
    json = {
      "site_attributes": {
        "dis_qus_integration": "",
        "youtube_url": site.youtube_url,
        "instagram_url": site.instagram_url,
        "twitter_url": site.twitter_url,
        "facebook_url": site.facebook_url,
        "house_colour": site.house_colour,
        "reverse_house_colour": site.reverse_house_colour,
        "font_colour": site.font_colour,
        "reverse_font_colour": site.reverse_font_colour,
        "logo_url": site.logo_image.present? ? site.logo_image.thumbnail_url : "",
        "favicon_url": site.favicon.present? ? site.favicon.thumbnail_url : "",
        "ga_code": site.g_a_tracking_id
      },
      "streams": Stream.where(col_name: 'Page', col_id: self.id).map {|e| "#{Datacast_ENDPOINT}/#{self.datacast_identifier}/index.json"},
      "page": self.as_json
    }
    key = "#{self.datacast_identifier}/page.json"
    encoded_file = Base64.encode64(json.to_json)
    content_type = "application/json"
    resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, key, content_type)
    true
  end

end