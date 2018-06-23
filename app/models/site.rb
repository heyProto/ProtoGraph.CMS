# == Schema Information
#
# Table name: sites
#
#  id                          :integer          not null, primary key
#  name                        :string(255)
#  domain                      :string(255)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  description                 :text(65535)
#  primary_language            :string(255)
#  default_seo_keywords        :text(65535)
#  house_colour                :string(255)
#  reverse_house_colour        :string(255)
#  font_colour                 :string(255)
#  reverse_font_colour         :string(255)
#  stream_url                  :text(65535)
#  stream_id                   :integer
#  cdn_provider                :string(255)
#  cdn_id                      :string(255)
#  host                        :text(65535)
#  cdn_endpoint                :text(65535)
#  client_token                :string(255)
#  access_token                :string(255)
#  client_secret               :string(255)
#  favicon_id                  :integer
#  logo_image_id               :integer
#  g_a_tracking_id             :string(255)
#  sign_up_mode                :string(255)
#  default_role                :string(255)
#  story_card_style            :string(255)
#  email_domain                :string(255)
#  header_background_color     :string(255)
#  header_url                  :text(65535)
#  header_positioning          :string(255)
#  slug                        :string(255)
#  is_english                  :boolean          default(TRUE)
#  english_name                :string(255)
#  story_card_flip             :boolean          default(FALSE)
#  created_by                  :integer
#  updated_by                  :integer
#  seo_name                    :string(255)
#  is_lazy_loading_activated   :boolean          default(TRUE)
#  comscore_code               :text(65535)
#  gtm_id                      :string(255)
#  is_smart_crop_enabled       :boolean          default(FALSE)
#  enable_ads                  :boolean          default(FALSE)
#  show_proto_logo             :boolean          default(TRUE)
#  tooltip_on_logo_in_masthead :string(255)
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
    include AssociableBySi
    #ASSOCIATIONS
    # has_many :folders
    # has_many :streams
    # has_many :activities
    has_many :ref_categories
    has_many :verticals, ->{where(genre: 'series')}, class_name: "RefCategory"
    # has_many :view_casts
    has_many :pages
    has_one :stream, primary_key: "stream_id", foreign_key: "id"
    belongs_to :logo_image, class_name: "Image", foreign_key: "logo_image_id", primary_key: "id", optional: true
    belongs_to :favicon, class_name: "Image", foreign_key: "favicon_id", primary_key: "id", optional: true
    has_many :permissions, ->{where(status: "Active", permissible_type: 'Site')}, foreign_key: "permissible_id", dependent: :destroy
    has_many :users, through: :permissions
    has_many :permission_invites, ->{where(permissible_type: 'Site')}, foreign_key: "permissible_id", dependent: :destroy

    # newly added
    has_many :view_casts, dependent: :destroy
    has_many :folders, dependent: :destroy
    has_many :uploads, dependent: :destroy
    has_many :activities, dependent: :destroy
    has_many :images, dependent: :destroy
    has_many :streams, dependent: :destroy

    #ACCESSORS
    accepts_nested_attributes_for :logo_image, :favicon
    attr_accessor :from_page, :skip_invalidation, :coming_from_new

    #VALIDATIONS
    validates :name, presence: true, uniqueness: true

    validates :domain, format: {:with => /[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}/ }, allow_blank: true, allow_nil: true, length: { in: 3..240 }, exclusion: { in: %w(gmail.com outlook.com yahoo.com mail.com),
    message: "%{value} is reserved." }

    #CALLBACKS
    before_create :before_create_set
    before_update :before_update_set
    after_create :after_create_set
    after_save :after_save_set
    after_update :after_update_publish_site_pages
    #SCOPE
    #OTHER

    def cdn_bucket
        if Rails.env.production?
            "site-#{self.slug.gsub("_", "")}-#{self.id}"
        else
            "dev.cdn.protograph"
        end
    end

    def template_cards
        if self.name == 'pykih'
            TemplateCard.all
        else
            TemplateCard.where("site_id = ? OR is_public = true", self.id)
        end
    end

    def template_data
        TemplateDatum.where("site_id = ? OR is_public = true", self.id)
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
        User.where(email: ["ritvvij.parrikh@pykih.com", "ab@pykih.com", "dhara.shah@pykih.com", "aashutosh.bhatt@pykih.com"]).each do |user|
            pykih_admins[user.email] = user
        end

        pykih_admins.each do |email, user|
            user.create_permission("Site", self.id, "owner",true)
        end
    end

    def set_english_name
        self.english_name = self.name if (self.is_english || self.english_name.blank?)
    end

    def sitemap_key
        "sitemap.xml.gz"
    end

    def sitemap_url
        "#{cdn_endpoint}/#{sitemap_key}"
    end

    def robot_txt_key
        "robots.txt"
    end

    # Iteally, we should create multiple sitemap.xml files one for each vertical.
    # As per the guide lines listed here: https://support.google.com/webmasters/answer/183668?hl=en
    # It is more efficient to break down sitemap to smaller chunks and compiling a sitemap index file and submitting a index file instead of individual sitemap files.

    def publish_sitemap
        require 'aws-sdk'
        SitemapGenerator::Sitemap.verbose = true
        SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(self.cdn_bucket,
            aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
            aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
            aws_region: 'ap-south-1'
        )

        site = self
        SitemapGenerator::Sitemap.create({
            default_host: self.cdn_endpoint,
            sitemaps_host: self.cdn_endpoint,
            public_path: "tmp/#{self.cdn_bucket}/"
        }) do
            site.pages.where(status: "published").each do |page|
                add "#{page.html_key}.html"
            end
        end
        SitemapGenerator::Sitemap.ping_search_engines
    end

    # If we have more than one sitemap, we can create a list one below the other.
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


    def all_members
        members = []
        self.permissions.not_hidden.each do |p|
            members << [p.name, p.id]
        end
        members.sort_by{|b| b[0].to_s}
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
        self.cdn_endpoint = ENV['AWS_S3_ENDPOINT'] if self.cdn_endpoint.blank?
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
        user_id = self.users.present? ? self.users.first.id : nil
        stream = Stream.create!({
            is_automated_stream: true,
            col_name: "Site",
            col_id: self.id,
            updated_by: user_id,
            created_by: user_id,
            site_id: self.id,
            title: self.name,
            description: "#{self.name} site stream",
            limit: 50
        })

        self.update_columns(stream_url: "#{self.cdn_endpoint}/#{stream.cdn_key}", stream_id: stream.id)
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
    end

    def after_save_set
        # PublishSiteJson.perform_async(self.id)
        # Thread.new do
        #     header_json = {
        #         "header_logo_url": "#{self.logo_image_id.present? ? self.logo_image.original_image.image_url : ''}",
        #         "header_background_color": "#{self.header_background_color}",
        #         "header_jump_to_link": "#{self.header_url}",
        #         "header_logo_position": "#{self.header_positioning}",
        #         "house_colour": "#{self.house_colour}",
        #         "reverse_house_colour": "#{self.reverse_house_colour}",
        #         "font_colour": "#{self.font_colour}",
        #         "reverse_font_colour": "#{self.reverse_font_colour}",
        #         "primary_language": "#{self.primary_language}",
        #         "story_card_style": "#{self.story_card_style}",
        #         "story_card_flip": self.story_card_flip,
        #         "favicon_url": "#{favicon.present? ? favicon.image_url : ""}",
        #         "show_proto_logo": show_proto_logo
        #     }
        #     key = "#{self.header_json_key}"
        #     encoded_file = Base64.encode64(header_json.to_json)
        #     content_type = "application/json"
        #     resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, key, content_type, self.cdn_bucket)
        #     Api::ProtoGraph::CloudFront.invalidate(self, ["/#{key}"], 1)
        #     ActiveRecord::Base.connection.close
        # end
    end

    def after_update_publish_site_pages
        if self.saved_change_to_is_lazy_loading_activated? or self.saved_change_to_comscore_code? or self.saved_change_to_gtm_id?
            self.pages.each do |p|
                PagePublisher.perform_async(p.id)
            end
        end
    end

end
