# == Schema Information
#
# Table name: feed_links
#
#  id              :integer          not null, primary key
#  ref_category_id :integer
#  link            :text(65535)
#  headline        :text(65535)
#  published_at    :datetime
#  description     :text(65535)
#  cover_image     :text(65535)
#  author          :string(255)
#  feed_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  view_cast_id    :integer
#

class FeedLink < ApplicationRecord
  
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #CONCERNS  
  #ASSOCIATIONS
  belongs_to :ref_category
  belongs_to :feed
  
  #ACCESSORS
  #VALIDATIONS
  validates :link, presence: true, format: {:with => /[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}/ }
  validates :ref_category_id, presence: true
  validates :feed_id, presence: true
  validates :headline, presence: true
  validates :pulished_at, presence: true
  #AB2TODO Check for uniquess of URL within ref_category_id before adding it THEN update it only if view_cast_id is null
  
  #CALLBACKS
  #SCOPE
  #OTHER
  #PRIVATE
  private
  
  
end
