# == Schema Information
#
# Table name: ref_categories
#
#  id          :integer          not null, primary key
#  site_id     :integer
#  genre       :string(255)
#  name        :string(255)
#  stream_url  :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  stream_id   :integer
#  is_disabled :boolean
#  created_by  :integer
#  updated_by  :integer
#  count       :integer          default(0)
#  name_html   :string(255)
#  slug        :string(255)
#

class RefCategory < ApplicationRecord
    #CONSTANTS
    #CUSTOM TABLES
    #GEMS
    extend FriendlyId
    friendly_id :name, use: :slugged
    #ASSOCIATIONS
    belongs_to :site
    has_one :stream, foreign_key: 'id', primary_key: 'stream_id'
    belongs_to :creator, class_name: "User", foreign_key: "created_by"
    belongs_to :updator, class_name: "User", foreign_key: "updated_by"
    has_many :navigations, class_name: "SiteVerticalNavigation", foreign_key: "ref_category_vertical_id", dependent: :destroy
    has_one :folder, foreign_key: 'ref_category_vertical_id'
    has_many :pages, foreign_key: 'ref_category_series_id'
    #ACCESSORS
    #VALIDATIONS
    validates :name, presence: true, uniqueness: {scope: :site}, length: { in: 3..15 }
    validates :genre, inclusion: {in: ["intersection", "sub intersection", "series"]}

    #CALLBACKS
    after_create :after_create_set
    before_update :before_update_set
    after_destroy :update_site_verticals
    #SCOPE
    #OTHER
    #PRIVATE

    def vertical_page
        self.pages.where(template_page_id: TemplatePage.where(name: "Homepage: Vertical").first.id).first
    end

    def vertical_page_url
        "#{self.site.cdn_endpoint}/#{self.site.slug}/#{self.slug}.html"
    end

    def view_casts
        ViewCast.where("#{genre}": self.name)
    end

    def vertical_header_key
        "#{self.site.slug}/#{self.slug}/navigation.json"
    end

    def vertical_header_url
        "#{self.site.cdn_endpoint}/#{vertical_header_key}"
    end

    private

    def before_update_set
        self.is_disabled = true if self.count > 0
        self.name = ActionView::Base.full_sanitizer.sanitize(self.name)
        self.name_html = self.name if self.name_html.blank?
        true
    end

    def after_create_set
        # s = Stream.create!({
        #     is_automated_stream: true,
        #     col_name: "RefCategory",
        #     col_id: self.id,
        #     account_id: self.site.account_id,
        #     title: self.name,
        #     description: "#{self.name} stream",
        #     limit: 50
        # })

        # Thread.new do
        #     s.publish_cards
        #     ActiveRecord::Base.connection.close
        # end

        # self.update_columns(stream_url: "#{s.site.cdn_endpoint}/#{s.cdn_key}", stream_id: s.id)

        # Create a new page object
        Page.create({account_id: self.site.account_id,
            site_id: self.site_id,
            headline: "#{self.name + " "*(50 - (self.name.length)) }",
            template_page_id: TemplatePage.where(name: 'Homepage: Vertical').first.id,
            ref_category_series_id: self.id,
            created_by: self.created_by,
            updated_by: self.updated_by,
            datacast_identifier: '',
            url: "#{vertical_page_url}"
        })
        #Update the site vertical json
        update_site_verticals
        key = self.vertical_header_key
        encoded_file = Base64.encode64([].to_json)
        content_type = "application/json"
        resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, key, content_type)
    end

    def update_site_verticals
        Thread.new do
            verticals_json = []
            self.site.verticals.each do |ver|
                verticals_json << {"name": "#{ver.name}","url": "#{ver.vertical_page_url}","new_window": true, "name_html": "#{ver.name_html}"}
            end
            key = "#{self.site.homepage_header_key}"
            encoded_file = Base64.encode64(verticals_json.to_json)
            content_type = "application/json"
            resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, key, content_type)
            if self.site.cdn_id != ENV['AWS_CDN_ID']
                Api::ProtoGraph::CloudFront.invalidate(self.site, ["/#{CGI.escape(key)}"], 1)
            end
            Api::ProtoGraph::CloudFront.invalidate(nil, ["/#{CGI.escape(key)}"], 1)
            ActiveRecord::Base.connection.close
        end
    end
end
