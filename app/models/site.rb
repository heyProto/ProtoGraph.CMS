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
#  stream_id            :integer
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
    has_many :ref_categories
    has_one :stream, primary_key: "stream_id", foreign_key: "id"
    #ACCESSORS
    #VALIDATIONS
    # validates :name, presence: true, uniqueness: {scope: :account}

    validates :domain, format: {:with => /[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}/ }, allow_blank: true, allow_nil: true, length: { in: 3..240 }, exclusion: { in: %w(gmail.com outlook.com yahoo.com mail.com),
    message: "%{value} is reserved." }
    #CALLBACKS
    # before_create :before_create_set
    # after_create :after_create_set
    #SCOPE
    #OTHER
    #PRIVATE
    private

    def before_create_set
        self.house_colour = "#000"
        self.reverse_house_colour = "#fff"
        self.font_colour = "#000"
        self.reverse_font_colour = "#fff"
    end

    def after_create_set
        user_id = account.users.present? ? account.users.first.id : nil
        stream = Stream.create!({
            is_automated_stream: true,
            col_name: "Site",
            col_id: self.id,
            updated_by: user_id,
            created_by: user_id,
            account_id: account_id,
            title: self.name,
            description: "#{self.name} stream",
            limit: 50
        })

        self.update_columns(stream_url: "#{self.account.cdn_endpoint}/#{stream.cdn_key}", stream_id: stream.id)

        ["genderand", "mobbed", 'jaljagran'].each do |series|
            cat = RefCategory.create({
                site_id: self.id,
                category: "series",
                name: series
            })

           s = Stream.create!({
                is_automated_stream: true,
                col_name: "RefCategory",
                col_id: cat.id,
                updated_by: user_id,
                created_by: user_id,
                account_id: account_id,
                title: self.name,
                description: "#{series} stream",
                limit: 50
            })

            Thread.new do
                s.publish_cards
                ActiveRecord::Base.connection.close
            end

            cat.update_columns(stream_url: "#{account.cdn_endpoint}/#{s.cdn_key}", stream_id: s.id)
        end
    end
end
