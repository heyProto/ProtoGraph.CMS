# == Schema Information
#
# Table name: sites
#
#  id                      :integer          not null, primary key
#  account_id              :integer
#  name                    :string(255)
#  domain                  :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  description             :text(65535)
#  primary_language        :string(255)
#  default_seo_keywords    :text(65535)
#  house_colour            :string(255)
#  reverse_house_colour    :string(255)
#  font_colour             :string(255)
#  reverse_font_colour     :string(255)
#  stream_url              :text(65535)
#  stream_id               :integer
#  cdn_provider            :string(255)
#  cdn_id                  :string(255)
#  host                    :text(65535)
#  cdn_endpoint            :text(65535)
#  client_token            :string(255)
#  access_token            :string(255)
#  client_secret           :string(255)
#  favicon_id              :integer
#  logo_image_id           :integer
#  facebook_url            :text(65535)
#  twitter_url             :text(65535)
#  instagram_url           :text(65535)
#  youtube_url             :text(65535)
#  g_a_tracking_id         :string(255)
#  sign_up_mode            :string(255)
#  default_role            :string(255)
#  story_card_style        :string(255)
#  email_domain            :string(255)
#  header_background_color :string(255)
#  header_url              :text(65535)
#  header_positioning      :string(255)
#  slug                    :string(255)
#  is_english              :boolean          default(TRUE)
#  english_name            :string(255)
#  story_card_flip         :boolean          default(FALSE)
#  created_by              :integer
#  updated_by              :integer
#  seo_name                :string(255)
#

#TODO AMIT - Handle created_by, updated_by - RP added retrospectively. Need migration of old rows and BAU handling.

class Site < ApplicationRecord
    #CONSTANTS
    SIGN_UP_MODES = ["Any email from your domain", "Invitation only"]
    #CUSTOM TABLES
    #GEMS
    before_validation :set_english_name
    extend FriendlyId
    friendly_id :english_name, use: :slugged
    #CONCERNS
    include Propagatable
    include AssociableByAc
    #ASSOCIATIONS
    has_many :folders
    has_many :streams
    has_many :activities
    has_many :ref_categories
    has_many :verticals, ->{where(genre: 'series')}, class_name: "RefCategory"
    has_many :view_casts
    has_many :pages
    has_one :stream, primary_key: "stream_id", foreign_key: "id"
    belongs_to :logo_image, class_name: "Image", foreign_key: "logo_image_id", primary_key: "id", optional: true
    belongs_to :favicon, class_name: "Image", foreign_key: "favicon_id", primary_key: "id", optional: true
    has_many :permissions, ->{where(status: "Active", permissible_type: 'Site')}, foreign_key: "permissible_id", dependent: :destroy
    has_many :users, through: :permissions
    has_many :permission_invites, ->{where(permissible_type: 'Site')}, foreign_key: "permissible_id", dependent: :destroy

    #ACCESSORS
    accepts_nested_attributes_for :logo_image, :favicon
    attr_accessor :from_page

    #VALIDATIONS
    validates :name, presence: true, uniqueness: {scope: :account}

    validates :domain, format: {:with => /[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}/ }, allow_blank: true, allow_nil: true, length: { in: 3..240 }, exclusion: { in: %w(gmail.com outlook.com yahoo.com mail.com),
    message: "%{value} is reserved." }
    # validates :facebook_url, format: {:with => /[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}/ }, allow_blank: true, allow_nil: true, length: { in: 9..240 }
    # validates :twitter_url, format: {:with => /[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}/ }, allow_blank: true, allow_nil: true, length: { in: 9..240 }
    # validates :instagram_url, format: {:with => /[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}/ }, allow_blank: true, allow_nil: true, length: { in: 9..240 }
    # validates :youtube_url, format: {:with => /[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}/ }, allow_blank: true, allow_nil: true, length: { in: 9..240 }

    #CALLBACKS
    before_create :before_create_set
    before_update :before_update_set
    after_create :after_create_set
    after_save :after_save_set
    #SCOPE
    #OTHER

    def cdn_bucket
        if Rails.env.production?
            "site-#{self.slug.gsub("_", "")}-#{self.id}"
        else
            "dev.cdn.protograph"
        end
    end

    def is_english
        self.primary_language == 'English'
    end

    def should_generate_new_friendly_id?
        slug.nil? || english_name_changed?
    end

    def homepage_header_key
        "verticals.json"
    end

    def homepage_header_url
        "#{cdn_endpoint}/#{homepage_header_key}"
    end

    def header_json_key
        "header.json"
    end

    def header_json_url
        "#{cdn_endpoint}/#{header_json_key}"
    end

    #PRIVATE
    def is_cdn_id_from_env?
        self.cdn_id == ENV['AWS_CDN_ID']
    end

    def is_host_from_env?
        self.host == "#{AWS_API_DATACAST_URL}/cloudfront/invalidate"
    end

    def is_cdn_endpoint_from_env?
        self.cdn_endpoint == ENV['AWS_S3_ENDPOINT']
    end

    def is_client_token_from_env?
        self.client_token == ENV['AWS_ACCESS_KEY_ID']
    end

    def is_client_secret_from_env?
        self.client_secret == ENV['AWS_SECRET_ACCESS_KEY']
    end

    def create_sudo_permission(role)
        pykih_admins = {}
        User.where(email: ["ritvvij.parrikh@pykih.com", "ab@pykih.com", "dhara.shah@pykih.com"]).each do |user|
            pykih_admins[user.email] = user
        end

        pykih_admins.each do |email, user|
            user.create_permission("Account", self.account_id, "owner",true)
        end
    end

    def set_english_name
        self.english_name = self.name if (self.is_english || self.english_name.blank?)
    end

    def sitemap_key
        "sitemap.xml"
    end

    def sitemap_url
        "#{cdn_endpoint}/#{sitemap_key}"
    end

    def robot_txt_key
        "robot.txt"
    end

    # <?xml version="1.0" encoding="UTF-8"?>
    # <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
    # <url>
    #     <loc>http://www.example.com/foo.html</loc>
    # </url>
    # </urlset>


    def publish_sitemap
        builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
            xml.urlset {
                xml.xmlns "http://www.sitemaps.org/schemas/sitemap/0.9"
                self.pages.each do |p|
                    puts p.html_url
                    xml.url {
                        xml.loc p.html_url
                    }
                end
            }
        end
        key = "#{self.sitemap_key}"
        encoded_file = Base64.encode64(builder.to_xml)
        content_type = "application/xml"
        resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, key, content_type, self.cdn_bucket)
        Api::ProtoGraph::CloudFront.invalidate(self, ["/#{key}"], 1)
    end

    def publish_robot_txt
        robot_txt = ""
        robot_txt += "User-agent: *\n"
        robot_txt += "Allow: /\n"
        robot_txt += "Sitemap: #{self.cdn_endpoint}/#{self.sitemap_key}\n"

        key = "#{self.robot_txt_key}"
        encoded_file = Base64.encode64(robot_txt)
        content_type = "plain/text"
        resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, key, content_type, self.cdn_bucket)
        Api::ProtoGraph::CloudFront.invalidate(self, ["/#{key}"], 1)
    end

    private


    def before_create_set
        self.house_colour = "#EE1C25"
        self.reverse_house_colour = "#4caf50"
        self.font_colour = "#FFFFFF"
        self.reverse_font_colour = "#FFFFFF"
        self.cdn_provider = "CloudFront"
        self.host = "#{AWS_API_DATACAST_URL}/cloudfront/invalidate"
        self.client_token = ENV['AWS_ACCESS_KEY_ID']
        self.client_secret = ENV['AWS_SECRET_ACCESS_KEY']
        self.story_card_style = 'Clear: Color'
        self.default_role = 'writer'
        self.primary_language = "English" if self.primary_language.nil?
        self.header_background_color = '#FFFFFF'
        self.header_positioning = "left"
        self.seo_name = self.name
        true
    end

    def before_update_set
        self.cdn_endpoint = ENV['AWS_S3_ENDPOINT'] if self.cdn_endpoint.blank?
        self.client_token = ENV['AWS_ACCESS_KEY_ID'] if self.client_token.blank?
        self.client_secret = ENV['AWS_SECRET_ACCESS_KEY'] if self.client_secret.blank?
        self.host = "#{AWS_API_DATACAST_URL}/cloudfront/invalidate" if self.host.blank?
        self.cdn_id = ENV['AWS_CDN_ID'] if self.cdn_id.blank? and self.cdn_endpoint == ENV['AWS_S3_ENDPOINT']
        true
    end

    def after_create_set
        # user_id = account.users.present? ? account.users.first.id : nil
        # stream = Stream.create!({
        #     is_automated_stream: true,
        #     col_name: "Site",
        #     col_id: self.id,
        #     updated_by: user_id,
        #     created_by: user_id,
        #     account_id: account_id,
        #     title: self.name,
        #     description: "#{self.name} stream",
        #     limit: 50
        # })

        # self.update_columns(stream_url: "#{self.cdn_endpoint}/#{stream.cdn_key}", stream_id: stream.id)
        create_sudo_permission("owner")
        key = "#{self.homepage_header_key}"
        encoded_file = Base64.encode64([].to_json)
        content_type = "application/json"
        # begin
        if Rails.env.production?
            resp = Api::ProtoGraph::Site.create_bucket_and_distribution(self.cdn_bucket)
            self.update_columns(
                    cdn_id: resp['cloudfront_response']['Distribution']['Id'],
                    cdn_endpoint: "https://#{resp['cloudfront_response']['Distribution']['DomainName']}"
            )
            resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, key, content_type, self.cdn_bucket)
        else
            self.update_columns(
                cdn_id: ENV["AWS_CDN_ID"],
                cdn_endpoint: ENV['AWS_S3_ENDPOINT']
            )
        end
        # rescue => e
        #     #Send email to AB
        # end
    end

    def after_save_set
        Thread.new do
            header_json = {
                "header_logo_url": "#{self.logo_image_id.present? ? self.logo_image.original_image.image_url : ''}",
                "header_background_color": "#{self.header_background_color}",
                "header_jump_to_link": "#{self.header_url}",
                "header_logo_position": "#{self.header_positioning}",
                "house_colour": "#{self.house_colour}",
                "reverse_house_colour": "#{self.reverse_house_colour}",
                "font_colour": "#{self.font_colour}",
                "reverse_font_colour": "#{self.reverse_font_colour}",
                "primary_language": "#{self.primary_language}",
                "story_card_style": "#{self.story_card_style}",
                "story_card_flip": self.story_card_flip,
                "favicon_url": "#{favicon.present? ? favicon.image_url : ""}"
            }
            key = "#{self.header_json_key}"
            encoded_file = Base64.encode64(header_json.to_json)
            content_type = "application/json"
            resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, key, content_type, self.cdn_bucket)
            Api::ProtoGraph::CloudFront.invalidate(self, ["/#{key}"], 1)
            ActiveRecord::Base.connection.close
        end
    end

end
