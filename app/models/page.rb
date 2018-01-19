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
#

class Page < ApplicationRecord
  
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  belongs_to :account
  belongs_to :site
  belongs_to :folder
  belongs_to :series, class_name: "RefCategory", foreign_id: :ref_category_series_id
  belongs_to :intersection, class_name: "RefCategory", foreign_id: :ref_category_intersection_id
  belongs_to :sub_intersection, class_name: "RefCategory", foreign_id: :ref_category_sub_intersection_id
  belongs_to :view_cast
  belongs_to :creator, class_name: "User", foreign_key: "created_by"
  belongs_to :updator, class_name: "User", foreign_key: "updated_by"
  has_many :page_streams
  has_many :streams, through: :page_streams
  
  #ACCESSORS
  #VALIDATIONS
  #CALLBACKS
  before_create :before_create_set
  
  #SCOPE
  #OTHER
  #PRIVATE
  private
  
  def before_create_set
    self.is_interactive = false                       if self.is_interactive.blank?
    self.has_data = false                             if self.has_data.blank?
    self.has_image_other_than_cover = false           if self.has_image_other_than_cover.blank?
    self.has_audio = false                            if self.has_audio.blank?
    self.has_video = false                            if self.has_video.blank?
    self.is_sponsored = false                         if self.is_sponsored.blank?
    self.is_published = false                         if self.is_published.blank?
    true
  end
  
  def before_save_set
    if self.has_data == true or self.has_image_other_than_cover == true or self.has_audio == true or self.has_video == true
      self.is_interactive = true
    end
    true
  end
  
end



validates :headline
validates :summary


#  layout                           :string(255)
#  byline                           :string(255)
#  byline_stream                    :string(255)
#  cover_image_url                  :text(65535)
#  cover_image_url_7_column         :text(65535)
#  cover_image_url_facebook         :text(65535)
#  cover_image_url_square           :text(65535)
#  cover_image_alignment            :string(255)
#  published_at                     :datetime
#  url                              :text(65535)
#  ref_category_series_id           :integer
#  ref_category_intersection_id     :integer
#  ref_category_sub_intersection_id :integer
#  view_cast_id                     :integer
#  page_object_url                  :text(65535)









