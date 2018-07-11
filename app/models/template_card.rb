# == Schema Information
#
# Table name: template_cards
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  elevator_pitch       :string(255)
#  description          :text
#  global_slug          :string(255)
#  is_current_version   :boolean
#  slug                 :string(255)
#  version_series       :string(255)
#  previous_version_id  :integer
#  version_genre        :string(255)
#  version              :string(255)
#  change_log           :text
#  status               :string(255)
#  publish_count        :integer
#  is_public            :boolean
#  git_url              :text
#  git_branch           :string(255)
#  created_by           :integer
#  updated_by           :integer
#  template_datum_id    :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  has_static_image     :boolean          default(FALSE)
#  git_repo_name        :string(255)
#  s3_identifier        :string(255)
#  has_multiple_uploads :boolean          default(FALSE)
#  has_grouping         :boolean          default(FALSE)
#  allowed_views        :text
#  sort_order           :integer
#  is_editable          :boolean          default(TRUE)
#  site_id              :integer
#

class TemplateCard < ApplicationRecord

    #CONSTANTS
    STATUS = ["Draft", "Ready to Publish", "Published", "Deactivated"]
    CDN_BASE_URL = "#{ENV['AWS_S3_ENDPOINT']}"
    PUBLISHED_COLUMN_MAP = {
        "toStory" => "publishedat",
        "toCluster" => "published_date"
    }
    serialize :allowed_views

    #CUSTOM TABLES
    #GEMS
    extend FriendlyId
    friendly_id :slug_candidates, use: :scoped, scope: [:site_id]
    #CONCERNS
    include AssociableBySi
    include Versionable
    #ASSOCIATIONS
    belongs_to :template_datum
    has_many :view_casts
    has_many :uploads

    #ACCESSORS
    attr_accessor :previous_version_id

    #VALIDATIONS
    validates :template_datum_id, presence: true
    validates :name, presence: true
    validates :created_by, presence: true
    validates :updated_by, presence: true

    #CALLBACKS
    before_create :before_create_set
    before_destroy :before_destroy_set

    #SCOPE
    scope :with_multiple_uploads, -> { where(has_multiple_uploads: true) }    #OTHER
    def slug_candidates
        ["#{self.name}-#{self.version.to_s}"]
    end

    def self.to_story_cards_ids
      TemplateCard.where(name: ["toArticle"]).pluck(:id).uniq
    end

    def deep_copy_across_versions
        p                           = self.previous
        v                           = p.version.to_s.to_version
        if self.version_genre == "major"
            self.version            = v.bump!(:major).to_s
        elsif self.version_genre == "minor"
            self.version            = v.bump!(:minor).to_s
        elsif self.version_genre == "bug"
            self.version            = v.bump!.to_s
        end
        self.name                   = p.name
        self.global_slug            = p.global_slug
        self.is_current_version     = false
        self.is_public              = p.is_public
        self.version_series         = self.version.to_s.to_version.to_a[0]
        self.description            = p.description
        self.elevator_pitch         = p.elevator_pitch
    end

    def can_make_public?
        (self.status == "Published" and self.template_datum.is_public) ? true : false
    end

    def can_ready_to_publish?
        if self.description.present?
            return true
        end
        return false
    end

    def site_slug
        puts self.site.inspect
        self.site.slug
    end

    def icon_url
        "#{base_url}/card.png"
    end

    def versions
        self.siblings.as_json(only: [:site_id, :id, :slug, :global_slug,:name, :elevator_pitch], methods: [:site_slug, :icon_url])
    end

    def base_url
        "#{TemplateCard::CDN_BASE_URL}/#{self.s3_identifier}"
    end

    def js
        "#{base_url}/card.min.js"
    end

    def css
        "#{base_url}/card.min.css"
    end

    def files
        obj = {
            "js": "#{js}",
            "css": "#{css}",
            "html": "#{index_html}",
            "configuration_schema": "#{base_url}/configuration_schema.json",
            "configuration_sample": "#{base_url}/configuration_sample.json",
            "ui_schema": "#{base_url}/ui_schema.json",
            "icon_url": "#{icon_url}",
            "schema_files": self.template_datum.files,
            "edit_file_js": "#{base_url}/edit-card.min.js",
            "protograph_html": "#{protograph_html}",
            "base_url": "#{base_url}"
        }

        obj["static_image"] = "#{base_url}/static_image.png" if self.has_static_image
        obj
    end

    def index_html
        "#{base_url}/index.html"
    end

    def protograph_html
        "#{base_url}/protograph.html"
    end

    def invalidate
        Api::ProtoGraph::CloudFront.invalidate(nil, ["/#{self.s3_identifier}/*"], 1)
    end

    class << self

        def get_seo_blockquote(card_name, data)
            if card_name == "toStory"
                return TemplateCard.to_story_render_SEO(data)
            else
                return TemplateCard.to_cluster_render_SEO(data)
            end
        end

        def to_story_render_SEO(data)
            "<blockquote><a href='#{data['url']}' rel='nofollow'>#{data['headline'] ? "<h2>#{data['headline']}</h2>" : ''}</a>#{data['byline'] ? "<p>#{data['byline']}</p>" : ''}#{data['publishedat'] ? "<p>#{data['publishedat']}</p>" : ''}#{data['series'] ? "<p>#{data['series']}</p>" : ''}#{data['genre'] ? "<p>#{data['genre']}</p>" : ''}#{data['subgenre'] ? "<p>#{data['subgenre']}</p>" : ''}#{data['summary'] ? "<p>#{data['summary']}</p>" : ''}</blockquote>"
        end

        def to_cluster_render_SEO(data)
            links_html = "<ul>"
            data["links"].each do |e|
                links_html += "<li><a href='#{e["link"]}' target='_blank' rel='nofollow'>#{e['publication_name']}</a></li>"
            end
            links_html += "</ul>";
            blockquote_string = "<blockquote><h1>#{data["title"]}</h1><p>#{data["published_date"]}</p>#{links_html}</blockquote>"
        end

        def to_cross_pub_SEO(data)
            blockquote_string = "<blockquote><h1>#{data["site_name"]}</h1><p>#{data["home_page_url"]}</p><p>#{data["summary"]}</p><p>#{data["ref_category_html"]}</p></blockquote>"
            blockquote_string
        end
    end


    #PRIVATE
    private

    def should_generate_new_friendly_id?
        slug.blank? || name_changed?
    end

    def before_create_set
        self.status = "Draft"
        self.publish_count = 0
        self.s3_identifier = SecureRandom.hex(6) if self.s3_identifier.blank?
        if self.previous_version_id.blank?
            self.global_slug = self.name.parameterize
            self.is_current_version = true
            self.version_series = "0"
            self.previous_version_id = nil
            self.version_genre = "major"
            self.version = "0.0.1"
            self.is_public = false unless self.is_public.present?
        end
        true
    end

    def before_destroy_set
        self.view_casts.destroy_all
    end
end
