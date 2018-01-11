# == Schema Information
#
# Table name: sites
#
#  id                   :integer          not null, primary key
#  account_id           :integer
#  name                 :string(255)
#  domain               :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  description          :text(65535)
#  primary_language     :string(255)
#  default_seo_keywords :text(65535)
#  house_colour         :string(255)
#  reverse_house_colour :string(255)
#  font_colour          :string(255)
#  reverse_font_colour  :string(255)
#  stream_url           :text(65535)
#

class Site < ApplicationRecord
    #CONSTANTS
    #CUSTOM TABLES
    #GEMS
    #ASSOCIATIONS
    belongs_to :account
    has_many :folders
    has_many :streams
    has_many :activities
    has_many :site_view_casts
    has_many :view_casts, through: :site_view_casts
    #ACCESSORS
    #VALIDATIONS
    validates :name, presence: true, uniqueness: {scope: :account}

    validates :domain, format: {:with => /[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}/ }, allow_blank: true, allow_nil: true, length: { in: 3..240 }, exclusion: { in: %w(gmail.com outlook.com yahoo.com mail.com),
    message: "%{value} is reserved." }
    #CALLBACKS
    #SCOPE
    #OTHER
    #PRIVATE
    private
end
