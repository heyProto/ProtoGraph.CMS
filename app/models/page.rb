# == Schema Information
#
# Table name: pages
#
#  id               :integer          not null, primary key
#  site_id          :integer
#  account_id       :integer
#  folder_id        :string(255)
#  headline         :string(255)
#  meta_description :text(65535)
#  publised_date    :datetime
#  is_published     :boolean
#  summary          :text(65535)
#  alignment        :string(255)
#  isinteractive    :boolean
#  genre            :string(255)
#  sub_genre        :string(255)
#  series           :string(255)
#  by_line          :string(255)
#  cover_image_id   :integer
#  created_by       :integer
#  updated_by       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Page < ApplicationRecord
    #CONSTANTS
    #CUSTOM TABLES
    #GEMS
    #ASSOCIATIONS
    belongs_to :account
    belongs_to :site
    belongs_to :folder
    has_many :page_streams
    has_many :streams, through: :page_streams
    #ACCESSORS
    #VALIDATIONS
    #CALLBACKS
    #SCOPE
    #OTHER
    #PRIVATE
end
