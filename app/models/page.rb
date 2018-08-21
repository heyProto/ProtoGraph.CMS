# == Schema Information
#
# Table name: pages
#
#  id                               :integer          not null, primary key
#  site_id                          :integer
#  folder_id                        :integer
#  headline                         :string(255)
#  meta_keywords                    :string(255)
#  meta_description                 :text
#  summary                          :text
#  cover_image_url_facebook         :text
#  cover_image_url_square           :text
#  cover_image_alignment            :string(255)
#  is_sponsored                     :boolean
#  is_interactive                   :boolean
#  has_data                         :boolean
#  has_image_other_than_cover       :boolean
#  has_audio                        :boolean
#  has_video                        :boolean
#  published_at                     :datetime
#  url                              :text
#  ref_category_series_id           :integer
#  ref_category_intersection_id     :integer
#  ref_category_sub_intersection_id :integer
#  view_cast_id                     :integer
#  page_object_url                  :text
#  created_by                       :integer
#  updated_by                       :integer
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  datacast_identifier              :string(255)
#  is_open                          :boolean
#  template_page_id                 :integer
#  slug                             :string(255)
#  english_headline                 :string(255)
#  status                           :string(255)
#  cover_image_id                   :integer
#  cover_image_id_7_column          :integer
#  due                              :date
#  description                      :text
#  cover_image_id_4_column          :integer
#  cover_image_id_3_column          :integer
#  cover_image_id_2_column          :integer
#  cover_image_credit               :string(255)
#  share_text_facebook              :text
#  share_text_twitter               :text
#  one_line_concept                 :string(255)
#  content                          :text
#  byline_id                        :integer
#  reported_from_country            :string(255)
#  reported_from_state              :string(255)
#  reported_from_district           :string(255)
#  reported_from_city               :string(255)
#  hide_byline                      :boolean          default(FALSE)
#  landing_card_id                  :integer
#  external_identifier              :string
#  html_key                         :string
#  format                           :string
#  importance                       :string           default("low")
#  cover_story_id                   :integer
#  image_narrative_id               :integer
#

class Page < ApplicationRecord

  #CONSTANTS
  STATUS = [["Draft", 'draft'],["Published", 'published']]
  BLACKLIST_DOMAIN_IDS = ["www", "com", "co", "us", "in", "net", "org", "to"]
  #CUSTOM TABLES
  #GEMS
  before_validation :before_validation_set
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  #CONCERNS
  include Propagatable
  include AssociableBySiFo
  #ASSOCIATIONS
  belongs_to :series, class_name: "RefCategory", foreign_key: :ref_category_series_id, optional: true
  belongs_to :intersection, class_name: "RefCategory", foreign_key: :ref_category_intersection_id, optional: true
  belongs_to :sub_intersection, class_name: "RefCategory", foreign_key: :ref_category_sub_intersection_id, optional: true
  belongs_to :byline, class_name: "Permission", foreign_key: :byline_id, optional: true
  belongs_to :view_cast, optional: true
  belongs_to :cover_story, class_name: "ViewCast", foreign_key: :cover_story_id, optional: true
  belongs_to :image_narrative, class_name: "ViewCast", foreign_key: :image_narrative_id, optional: true
  belongs_to :template_page
  belongs_to :col7_cover_image, class_name: "ImageVariation", foreign_key: "cover_image_id_7_column", optional: true
  belongs_to :cover_image, class_name: "Image", optional: true
  has_one :landing_card, class_name: "ViewCast", primary_key: "landing_card_id", foreign_key: "id"
  has_many :page_streams
  has_many :streams, through: :page_streams
  has_many :permissions, ->{where(status: "Active", permissible_type: 'Page')}, foreign_key: "permissible_id", dependent: :destroy
  has_many :users, through: :permissions
  has_many :ad_integrations

  #ACCESSORS
  attr_accessor :collaborator_lists, :publish, :from_api, :prepare_cards_for_assembling, :from_page, :skip_invalidation, :import_url
  accepts_nested_attributes_for :cover_image

  #VALIDATIONS
  validates :headline, presence: true, length: { in: 5..90 }
  validates :one_line_concept, presence: true, length: { in: 5..90 }, allow_blank: true
  validates :summary, length: { in: 50..220 }, allow_blank: true
  validates :html_key,  format: {with: /\A[^\s!#$%^&*()（）=+;:'"\[\]\{\}|\\@#<>?,]+\z/ }, length: { in: 5..255 }, on: :update

  #CALLBACKS
  before_create :before_create_set
  before_save :before_save_set

  after_save :after_save_set
  after_create :set_url
  after_create :create_page_streams
  after_create :push_json_to_s3
  after_update :update_page_image
  after_update :create_paragraph_card, if: "self.prepare_cards_for_assembling=='true'"
  after_update :push_json_to_s3
  after_commit :update_slug, on: :create


  # Slug
  def before_validation_set
    self.english_headline = self.headline if (self.site.is_english and self.english_headline.blank?)
  end

  def html_key_old
    if template_page.name == 'Homepage: Vertical'
      "#{self.series.slug}.html"
    else
      "stories/#{self.slug}.html"
    end
  end

  def html_url
    "#{self.site.cdn_endpoint}/#{html_key}"
  end

  def series_7c_stream
    vertical_page = series.vertical_page
    vertical_page.streams.where(title: "#{vertical_page.id}_Section_7c").first
  end

  def is_published
    self.status == 'published' or self.status == "publish"
  end

  def cover_image_url
    if self.cover_image.present?
      self.cover_image.image_url
    else
      ""
    end
  end

  def cover_image_url_7_column
    if self.col7_cover_image.present?
      self.col7_cover_image.image_url
    else
      ""
    end
  end

  def slug_candidates
    if template_page.name == 'Homepage: Vertical'
      "#{english_headline}"
    else
      "#{english_headline}-#{id}"
    end
  end

  def update_slug
    unless template_page.name == 'Homepage: Vertical'
      unless slug.split("-")[-1]  == self.id.to_s
        self.slug = nil
        self.save
      end
    end
  end

  #SCOPE
  #OTHER

  def should_generate_new_friendly_id?
    self.slug.nil? || english_headline_changed?
  end

  def remove_nofollow_if_match_domain(seo_blockquote, site_hostname_arrs)
    parsed_html = Nokogiri::HTML(seo_blockquote)
    parsed_html.search("a").each do |a_tag|
      a_tag_attributes = a_tag.attributes
      url = a_tag_attributes['href'].value
      url_hostname_arrs = URI.parse(url.to_s.strip).hostname.split(".")
      url_hostname_arrs.reject! {|r| Page::BLACKLIST_DOMAIN_IDS.include?(r)}
      if (url_hostname_arrs & site_hostname_arrs).length > 0
        a_tag.remove_attribute('rel')
      end
    end
    return parsed_html.search("blockquote").to_s
  end

  def get_major_stream_blockquotes
    #Change code to remove nofollow here
    site_hostname_arrs = URI.parse(self.site.cdn_endpoint).hostname.split(".")
    site_hostname_arrs.reject! {|r| Page::BLACKLIST_DOMAIN_IDS.include?(r)}
    major_stream_blockquotes = {}
    case self.template_page.name
    when 'Homepage: Vertical'
      major_streams = ["#{self.id}_Section_16c_Hero", "#{self.id}_Section_7c", "#{self.id}_Section_4c" , "#{self.id}_Section_3c", "#{self.id}_Section_2c", "#{self.id}_Section_credits", "#{self.id}_Section_cta"]
    when 'article'
      major_streams = ["#{self.id}_Story_16c_Hero", "#{self.id}_Story_Narrative", "#{self.id}_Story_Related"]
    else
      major_streams = ["#{self.id}_Data_credits"]
    end

    self.streams.each do |stream|
      if (major_streams & [stream.title]).length > 0
        major_stream_blockquotes[stream.title] = []
        stream.cards.each do |card|
          seo_blockquote = card.seo_blockquote
          if ["toStory", "toCluster"].include?(card.template_card.name)
            seo_blockquote = remove_nofollow_if_match_domain(seo_blockquote, site_hostname_arrs)
          end
          major_stream_blockquotes[stream.title] << [card.datacast_identifier, seo_blockquote]
        end
      end
    end
    major_stream_blockquotes
  end

  def push_page_object_to_s3
    create_story_card unless self.template_page.name == "Homepage: Vertical"
    create_landing_card if self.template_page.name == "Homepage: Vertical"
    site = self.site
    hero_stream = self.streams.where(title: ["#{self.id}_Story_16c_Hero", "#{self.id}_Data_16c_Hero"]).first # "#{self.id}_Section_16c_Hero",
    if hero_stream.present? and hero_stream.cards.count == 0
      StreamEntity.create({
        "entity_value": "#{self.cover_story_id}",
        "entity_type": "view_cast_id",
        "stream_id": hero_stream.id,
        "is_excluded": false
      })
      hero_stream.reload
      hero_stream.publish_cards
      hero_stream.publish_rss
    end
    narrative_stream = self.streams.where(title: "#{self.id}_Story_Narrative").first
    if self.template_page.name == 'article' and self.cover_image.present? and self.image_narrative.present?
      if narrative_stream.stream_entities.where(entity_value: "#{self.image_narrative_id}", entity_type: "view_cast_id").count == 0
        StreamEntity.create({
          "entity_value": "#{self.image_narrative_id}",
          "entity_type": "view_cast_id",
          "stream_id": narrative_stream.id,
          "is_excluded": false,
          "sort_order": -1
        })
        narrative_stream.reload
        narrative_stream.publish_cards
        narrative_stream.publish_rss
      end
    else
      image_narrative_entities = narrative_stream.stream_entities.where(sort_order: -1)
      if image_narrative_entities.count > 0
        image_narrative_entities.delete_all
        narrative_stream.reload
        narrative_stream.publish_cards
        narrative_stream.publish_rss
      end
    end
    streams = self.page_streams.includes(:stream).map do |e|
      k = e.stream.as_json
      h = {}
      h['id'] = k['id']
      h['title'] = k['title']
      h['datacast_identifier'] = k['datacast_identifier']
      h['url'] = "#{self.site.cdn_endpoint}/#{k['datacast_identifier']}/index.json"
      h['name_of_stream'] = e.name_of_stream
      h['ads'] = e.ad_integration_json
      h
    end

    page = self.as_json(methods: [:html_key, :cover_image_url, :cover_image_url_7_column], include: [:ad_integrations])
    page['layout'] = self.template_page.as_json(methods: [:template_page_bucket, :template_page_endpoint])
    navigation_json = self.get_navigation_json if self.template_page.is_article_page?

    json = {
      "site_attributes": {
        "name": site.name,
        "dis_qus_integration": "",
        "house_colour": site.house_colour,
        "reverse_house_colour": site.reverse_house_colour,
        "font_colour": site.font_colour,
        "reverse_font_colour": site.reverse_font_colour,
        "logo_url": site.logo_image.present? ? site.logo_image.image_url : "",
        "favicon_url": site.favicon.present? ? site.favicon.image_url : "",
        "ga_code": site.g_a_tracking_id,
        "story_card_style": site.story_card_style,
        "primary_language": site.primary_language,
        "seo_name": site.seo_name,
        "is_lazy_loading_activated": site.is_lazy_loading_activated,
        "comscore_code": site.comscore_code,
        "gtm_id": site.gtm_id,
        "is_ad_enabled": site.enable_ads,
        "cdn_endpoint": site.cdn_endpoint
      },
      "page": page,
      "page_url": self.html_url,
      "page_imageurl": self.cover_image_url.present? ? self.cover_image_url.to_s : "",
      "page_author": (self.byline.present? and self.byline.username.present?) ? self.byline.username : "",
      "ref_category_object": {"name": "#{self.series.name}", "name_html": "#{self.series.name_html}"},
      "vertical_header_json_url": "#{self.series.vertical_header_url}",
      "homepage_header_json_url": "#{self.site.homepage_header_url}",
      "site_header_json_url": "#{self.site.header_json_url}"
    }
    series_stream = self.series.stream
    json["more_in_the_series"] = {
      "id": series_stream.id,
      "title": "#{series.name} stream",
      "datacast_identifier": series_stream.datacast_identifier,
      "rss_url": "#{site.cdn_endpoint}/#{series_stream.cdn_rss_key}",
      "url": "#{site.cdn_endpoint}/#{series_stream.cdn_key}",
      "name_of_stream": "MORE IN #{series.name.upcase}"
    }
    site_stream = self.site.stream
    json["more_in_the_site"] = {
      "id": site_stream.id,
      "title": "#{site.name} stream",
      "datacast_identifier": site_stream.datacast_identifier,
      "rss_url": "#{site.cdn_endpoint}/#{site_stream.cdn_rss_key}",
      "url": "#{site.cdn_endpoint}/#{site_stream.cdn_key}",
      "name_of_stream": "MORE IN #{site.name.upcase}"
    }
    json["navigation_json"] = navigation_json
    if self.intersection.present?
      intersection_stream = self.intersection.stream
      json["more_in_the_intersection"] = {
        "id": intersection_stream.id,
        "title": "#{intersection.name} stream",
        "datacast_identifier": intersection_stream.datacast_identifier,
        "rss_url": "#{site.cdn_endpoint}/#{intersection_stream.cdn_rss_key}",
        "url": "#{site.cdn_endpoint}/#{intersection_stream.cdn_key}",
        "name_of_stream": "MORE IN #{intersection.name.upcase}"
      }
    end
    if self.sub_intersection.present?
      sub_intersection_stream = self.sub_intersection.stream
      json["more_in_the_sub_intersection"] = {
        "id": sub_intersection_stream.id,
        "title": "#{sub_intersection.name} stream",
        "datacast_identifier": sub_intersection_stream.datacast_identifier,
        "rss_url": "#{site.cdn_endpoint}/#{sub_intersection_stream.cdn_rss_key}",
        "url": "#{site.cdn_endpoint}/#{sub_intersection_stream.cdn_key}",
        "name_of_stream": "MORE IN #{sub_intersection.name.upcase}"
      }
    end
    key = "#{self.html_key}"
    encoded_file = Base64.encode64(json.to_json)
    content_type = "application/json"
    resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, key, content_type, self.site.cdn_bucket)
    response = Api::ProtoGraph::Page.create_or_update_page(self.datacast_identifier, self.template_page.s3_identifier, self.site.cdn_bucket, ENV['AWS_S3_ENDPOINT'])
    if Rails.env.production?
      site.publish_sitemap
      site.publish_robot_txt
    end
    if self.template_page.name != 'Homepage: Vertical' and self.saved_changes.transform_values(&:first).keys.include?('published_at')
      self.series.vertical_page.push_page_object_to_s3
    end
    true
  end

  def get_navigation_json
    narrative_stream = self.streams.where(title: "#{self.id}_Story_Narrative").first
    nav_json = []
    if narrative_stream.present?
      narrative_stream_cards = narrative_stream.cards
      narrative_stream_cards.each do |card|
        data = card.data_json
        json = {
          "section": data["data"]["section"] || "",
          "view_cast_identifier": card.datacast_identifier,
          "view_cast_id": card.id
        }
        nav_json << json
      end
    end
    nav_json
  end

  class << self
    def collect_between(first, last=nil, include_last=false)
      a = []
      if first.nil? and last.present?
        a = [last]
      elsif last.nil?
        a = [first]
      elsif first == last
        a = []
      else
        a =[first, *collect_between(first.next, last)]
      end
      a << last if include_last
      return a
    end

    def get_title(text)
      html_text = Nokogiri::HTML(text)
      h2_tag = html_text.search("h2:first")
      if h2_tag.present?
        return h2_tag.children.first.to_s[0..80].strip
      else
        return html_text.xpath("//text()").to_s[0..80].strip
      end
    end

    def get_section(html_text)
      parsed_html_text = Nokogiri::HTML(html_text)
      h2_tag = parsed_html_text.search("h2:first")
      h2_tag.present? ? h2_tag.children.text : ""
    end

  end

  def collect_all_paras
    #all_elements = Nokogiri::HTML(content)
    paragraphs = []
    all_elements = Nokogiri::HTML(content).search('body').children
    first_element = all_elements.first
    all_h2_elements = all_elements.search("h2")
    last_element = all_elements.last
    if all_h2_elements.count > 0
      unless first_element == all_h2_elements.first
        html_part = ""
        Page.collect_between(first_element, all_h2_elements.first).each do |elem|
          html_part += elem.to_s
        end
        paragraphs << html_part
      end
      all_h2_elements.each_with_index do |h2, i|
        html_part = ""
        Page.collect_between(h2, all_h2_elements[i+1]).each do |elem|
          html_part += elem.to_s
        end
        paragraphs << html_part
      end
      unless (last_element == all_h2_elements.last)
        html_part = ""
        Page.collect_between(all_h2_elements.last, last_element, include_last: true).each do |elem|
          html_part += elem.to_s
        end
        paragraphs[-1] = html_part
      end
    else
      paragraphs << all_elements.to_s
    end
    paragraphs
  end

  def push_json_to_s3
    transformed_keys = self.saved_changes.transform_values(&:first)
    if self.status != "draft" and transformed_keys.present? and  (["url","is_open","due","description","one_line_concept","content"] & self.saved_changes.transform_values(&:first).keys).length == 0
      if self.from_api
        push_page_object_to_s3
      else
        # push_page_object_to_s3
        PagePublisher.perform_async(self.id)
      end
    end
  end

  def create_story_card
    if self.status != 'draft'
      site = self.site
      payload_json = create_datacast_json
      # Creating Story Card
      if self.view_cast.present?
        view_cast = self.view_cast
        view_cast.update({
          name: self.headline,
          seo_blockquote: TemplateCard.to_story_render_SEO(payload_json["data"]),
          folder_id: self.folder_id,
          by_line: (self.byline.present? and self.byline.username.present?) ? self.byline.username : "",
          ref_category_intersection_id: self.ref_category_intersection_id,
          ref_category_sub_intersection_id: self.ref_category_sub_intersection_id,
          is_autogenerated: true,
          updated_by: self.updated_by,
          byline_id: self.byline_id,
          published_at: self.published_at,
          data_json: payload_json
        })
      else
        view_cast = ViewCast.create({
          name: self.headline,
          site_id: site.id,
          template_card_id: TemplateCard.where(name: 'toStory').first.id,
          template_datum_id: TemplateDatum.where(name: 'toStory').first.id,
          seo_blockquote:  TemplateCard.to_story_render_SEO(payload_json["data"]),
          folder_id: self.folder_id,
          default_view: "title_text",
          by_line: (self.byline.present? and self.byline.username.present?) ? self.byline.username : "",
          ref_category_intersection_id: self.ref_category_intersection_id,
          ref_category_sub_intersection_id: self.ref_category_sub_intersection_id,
          created_by: self.created_by,
          updated_by: self.updated_by,
          is_autogenerated: true,
          byline_id: self.byline_id,
          ref_category_vertical_id: self.ref_category_series_id,
          published_at: self.published_at,
          data_json: payload_json
        })
      end
      payload = {}
      payload["payload"] = payload_json.to_json
      payload["api_slug"] = view_cast.datacast_identifier
      payload["schema_url"] = view_cast.template_datum.schema_json
      payload["source"] = "form"
      payload["bucket_name"] = site.cdn_bucket
      if self.view_cast.present?
        r = Api::ProtoGraph::Datacast.update(payload)
      else
        r = Api::ProtoGraph::Datacast.create(payload)
        self.update_column(:view_cast_id, view_cast.id)
      end

      #Creating CoverStory Card
      if self.cover_story.present?
        cover_story_card = self.cover_story
        cover_story_card.update({
          name: self.headline,
          seo_blockquote: "",
          folder_id: self.folder_id,
          by_line: (self.byline.present? and self.byline.username.present?) ? self.byline.username : "",
          ref_category_intersection_id: self.ref_category_intersection_id,
          ref_category_sub_intersection_id: self.ref_category_sub_intersection_id,
          is_autogenerated: true,
          updated_by: self.updated_by,
          byline_id: self.byline_id,
          published_at: self.published_at,
          data_json: payload_json
        })
      else
        cover_story_card = ViewCast.create({
          name: self.headline,
          site_id: site.id,
          template_card_id: TemplateCard.where(name: 'toCoverStory').first.id,
          template_datum_id: TemplateDatum.where(name: 'ProtoGraph.Card.toCoverStory').first.id,
          seo_blockquote:  "",
          folder_id: self.folder_id,
          default_view: "",
          by_line: (self.byline.present? and self.byline.username.present?) ? self.byline.username : "",
          ref_category_intersection_id: self.ref_category_intersection_id,
          ref_category_sub_intersection_id: self.ref_category_sub_intersection_id,
          created_by: self.created_by,
          updated_by: self.updated_by,
          is_autogenerated: true,
          byline_id: self.byline_id,
          ref_category_vertical_id: self.ref_category_series_id,
          published_at: self.published_at,
          data_json: payload_json
        })
      end
      payload = {}
      payload["payload"] = payload_json.to_json
      payload["api_slug"] = cover_story_card.datacast_identifier
      payload["schema_url"] = cover_story_card.template_datum.schema_json
      payload["source"] = "form"
      payload["bucket_name"] = site.cdn_bucket
      if self.cover_story.present?
        r = Api::ProtoGraph::Datacast.update(payload)
      else
        r = Api::ProtoGraph::Datacast.create(payload)
        self.update_column(:cover_story_id, cover_story_card.id)
      end
      #Creating ImageNarrative Card
      if self.cover_image.present?
        narrative_json = create_image_narrative_data_json
        if self.image_narrative.present?
          image_narrative = self.image_narrative
          image_narrative.update({
            name: self.headline,
            seo_blockquote: "",
            folder_id: self.folder_id,
            by_line: (self.byline.present? and self.byline.username.present?) ? self.byline.username : "",
            ref_category_intersection_id: self.ref_category_intersection_id,
            ref_category_sub_intersection_id: self.ref_category_sub_intersection_id,
            is_autogenerated: true,
            updated_by: self.updated_by,
            byline_id: self.byline_id,
            published_at: self.published_at,
            data_json: narrative_json
          })
        else
          image_narrative = ViewCast.create({
            name: self.headline,
            site_id: site.id,
            template_card_id: TemplateCard.where(name: 'toImageNarrative').first.id,
            template_datum_id: TemplateDatum.where(name: 'ProtoGraph.Card.toImageNarrative').first.id,
            seo_blockquote:  "",
            folder_id: self.folder_id,
            by_line: (self.byline.present? and self.byline.username.present?) ? self.byline.username : "",
            ref_category_intersection_id: self.ref_category_intersection_id,
            ref_category_sub_intersection_id: self.ref_category_sub_intersection_id,
            created_by: self.created_by,
            updated_by: self.updated_by,
            is_autogenerated: true,
            byline_id: self.byline_id,
            ref_category_vertical_id: self.ref_category_series_id,
            published_at: self.published_at,
            data_json: narrative_json
          })
        end
        payload = {}
        payload["payload"] = narrative_json.to_json
        payload["api_slug"] = image_narrative.datacast_identifier
        payload["schema_url"] = image_narrative.template_datum.schema_json
        payload["source"] = "form"
        payload["bucket_name"] = site.cdn_bucket
        if self.image_narrative.present?
          r = Api::ProtoGraph::Datacast.update(payload)
        else
          r = Api::ProtoGraph::Datacast.create(payload)
          self.update_column(:image_narrative_id, image_narrative.id)
        end
      end

      Api::ProtoGraph::CloudFront.invalidate(self.site, ["/#{view_cast.datacast_identifier}/*", "/#{cover_story_card.datacast_identifier}/*","/#{image_narrative.datacast_identifier}/*"], 3)
    end
    true
  end

  def create_datacast_json
    data = {"data" => {}}
    data["data"]["url"] = self.html_url.to_s if self.html_url.present?
    data["data"]["headline"] = self.headline.to_s if self.headline.present?
    data["data"]["byline"] = (self.byline.present? and self.byline.username.present?) ? self.byline.username : "   "
    data["data"]["publishedat"] = self.published_at.strftime("%Y-%m-%dT%H:%M:%S") if self.published_at.present?
    data["data"]["hide_byline"] = self.hide_byline || false
    data["data"]["series"] = self.series.name.to_s if self.series.present? and self.series.name.present?
    data["data"]["genre"] = self.intersection.name.to_s if self.intersection.present? and self.intersection.name.present?
    data["data"]["subgenre"] = self.sub_intersection.name.to_s if self.sub_intersection.present? and self.sub_intersection.name.present?
    data["data"]["iconbgcolor"] = "white"
    data["data"]["hasimage"] = self.has_image_other_than_cover if self.has_image_other_than_cover.present?
    data["data"]["hasvideo"] = self.has_video if self.has_video.present?
    data["data"]["hasdata"] = self.has_data if self.has_data.present?
    data["data"]["interactive"] = self.is_interactive if self.is_interactive.present?
    data["data"]["imageurl"] = self.cover_image_url.to_s if self.cover_image_url.present?
    data["data"]["col7imageurl"] = self.cover_image_url_7_column.to_s if self.cover_image_url_7_column.present?
    data["data"]["focus"] = (self.cover_image_alignment == "horizontal") ? "h" : "v"
    data["data"]["country"] = "India"
    data["data"]["state"] = ""
    data["data"]["city"] = ""
    data["data"]["sponsored"] = self.is_sponsored.to_s if self.is_sponsored.present?
    data["data"]["domainurl"] = Addressable::URI.parse(self.url.to_s).origin if self.url.present?
    data["data"]["faviconurl"] = site.favicon.present? ? "#{site.cdn_endpoint}/#{site.favicon.thumbnail_key}" : "" if self.site.favicon.present?
    data["data"]["publishername"] = Addressable::URI.parse(self.url.to_s).origin if self.url.present?
    data["data"]["col7imageurl"] = self.cover_image_url_7_column.to_s if self.cover_image_url_7_column.present?
    data["data"]["format"] = self.format if self.format.present?
    data["data"]["importance"] = self.importance if self.importance.present?
    data["data"]["external_identifier"] = self.external_identifier if self.external_identifier.present?
    if self.summary.present?
      data['data']['summary'] = self.summary
    end
    data
  end

  def create_image_narrative_data_json
    data = {"data" => {
      "img_url": "#{cover_image_url}"
    }}
    data
  end

  def create_landing_card
    if self.status != 'draft'
      site = self.site
      payload_json = {"data" => {}}
      payload_json["data"]["site_name"] = site.name
      payload_json["data"]["home_page_url"] = self.html_url
      payload_json["data"]["ref_category_html"] = self.series.name_html
      payload_json["data"]["show_by_publisher_in_header"] =  self.series.show_by_publisher_in_header
      payload_json["data"]["summary"] = self.summary
      payload_json["data"]["streams"] = self.streams.map {|s| { url: "#{site.cdn_endpoint}/#{s.cdn_key}" }}

      if self.landing_card.present?
        view_cast = self.landing_card
        view_cast.update({
          name: self.headline,
          seo_blockquote: TemplateCard.to_cross_pub_SEO(payload_json["data"]),
          folder_id: self.folder_id,
          by_line: (self.byline.present? and self.byline.username.present?) ? self.byline.username : "",
          ref_category_intersection_id: self.ref_category_intersection_id,
          ref_category_sub_intersection_id: self.ref_category_sub_intersection_id,
          is_autogenerated: true,
          updated_by: self.updated_by,
          byline_id: self.byline_id,
          published_at: self.published_at,
          data_json: payload_json
        })
        is_updating = true
      else
        view_cast = ViewCast.create({
          name: self.headline,
          site_id: site.id,
          template_card_id: TemplateCard.where(name: 'toCrossPub').first.id,
          template_datum_id: TemplateDatum.where(name: 'toCrossPub').first.id,
          seo_blockquote: TemplateCard.to_cross_pub_SEO(payload_json["data"]),
          folder_id: self.folder_id,
          default_view: "title_text",
          by_line: (self.byline.present? and self.byline.username.present?) ? self.byline.username : "",
          ref_category_intersection_id: self.ref_category_intersection_id,
          ref_category_sub_intersection_id: self.ref_category_sub_intersection_id,
          created_by: self.created_by,
          updated_by: self.updated_by,
          is_autogenerated: true,
          byline_id: self.byline_id,
          ref_category_vertical_id: self.ref_category_series_id,
          published_at: self.published_at,
          data_json: payload_json,
          external_identifier: self.external_identifier
        })
        is_updating = false
      end
      payload = {}
      payload["payload"] = payload_json.to_json
      payload["api_slug"] = view_cast.datacast_identifier
      payload["schema_url"] = view_cast.template_datum.schema_json
      payload["source"] = "form"
      payload["bucket_name"] = site.cdn_bucket
      if is_updating
        r = Api::ProtoGraph::Datacast.update(payload)
      else
        r = Api::ProtoGraph::Datacast.create(payload)
        self.update_column(:landing_card_id, view_cast.id)
      end
      Api::ProtoGraph::CloudFront.invalidate(self.site, ["/#{view_cast.datacast_identifier}/*"], 1)
    end
    true
  end

  def create_paragraph_card
    to_para_card = TemplateCard.where(name: 'toParagraph').first
    to_para_schema = TemplateDatum.where(name: 'toParagraph').first
    all_paras = collect_all_paras
    narrative_stream = streams.where("title LIKE ?", "%Narrative").first
    view_cast_lists = []
    all_paras.each do |para|
      title = Page.get_title(para)
      section = Page.get_section(para)
      payload_json = {"data": {"text": para, "section": section}}
      view_cast = ViewCast.create({
        name: title,
        site_id: site.id,
        template_card_id: to_para_card.id,
        template_datum_id: to_para_schema.id,
        created_by: created_by,
        updated_by: updated_by,
        seo_blockquote: "<blockquote><h4>#{title}</h4><p>#{para}</p></blockquote>",
        folder_id: folder_id,
        is_autogenerated: true,
        optionalconfigjson: {}.to_json,
        data_json: payload_json
      })
      payload = {}
      payload["payload"] = payload_json.to_json
      payload["api_slug"] = view_cast.datacast_identifier
      payload["schema_url"] = to_para_schema.schema_json
      payload["source"] = "form"
      payload["bucket_name"] = site.cdn_bucket
      r = Api::ProtoGraph::Datacast.create(payload)
      view_cast_lists << view_cast.id
    end
    view_cast_lists += narrative_stream.view_cast_ids.pluck(:entity_value)
    view_cast_lists.delete("#{self.image_narrative_id}")
    narrative_stream.cards.each do |card|
      if card.template_card_id == to_para_card.id and card.is_autogenerated
        view_cast_lists.delete("#{card.id}")
        card.destroy
      end
    end
    narrative_stream.view_cast_ids.where.not(entity_value: "#{self.image_narrative_id}").delete_all
    narrative_stream.update(view_cast_id_list: [view_cast_lists.reverse.join(",")])
    StreamPublisher.perform_async(narrative_stream.id)
  end

  #PRIVATE
  private

  def update_page_image
    if self.cover_image.present? and self.cover_image_id_7_column.nil? and self.cover_image.id.present? and self.cover_image.image_variation.first.present?
      self.update_column(:cover_image_id_7_column, self.cover_image.image_variation.first.id)
    end
  end

  def before_create_set
    self.datacast_identifier = SecureRandom.hex(12)   if self.datacast_identifier.blank?
    self.is_interactive = false                       if self.is_interactive.blank?
    self.has_data = false                             if self.has_data.blank?
    self.has_image_other_than_cover = false           if self.has_image_other_than_cover.blank?
    self.has_audio = false                            if self.has_audio.blank?
    self.has_video = false                            if self.has_video.blank?
    self.is_sponsored = false                         if self.is_sponsored.blank?
    self.status = 'draft'                             if self.status.blank?
    self.cover_image_alignment = "horizontal"         if self.cover_image_alignment.blank?
    self.html_key = self.html_key_old
    true
  end

  def before_save_set
    if self.has_data == true or self.has_image_other_than_cover == true or self.has_audio == true or self.has_video == true
      self.is_interactive = true
    end
    self.status = 'published' if self.publish == '1'
    if self.cover_image_id.blank?
      self.cover_image_id_7_column = nil
    end
    if self.content_changed?
      self.content = self.content.gsub(/<div.*?>|<\/div>/, '')
    end
    true
  end

  def set_url
    self.url = "#{self.html_url}" if self.url.blank?
  end

  def create_page_streams
    streams = []
    case self.template_page.name
    when 'Homepage: Vertical'
      streams = [["Section_16c_Hero", "Hero"], ["Section_7c", "Read"], ["Section_4c", "Join"], ["Section_3c", "Scan"], ["Section_2c", "Talk"], ["Section_credits", "Credits"], ["Section_cta", "CTA"], ["Section_footer", "Footer"]]
    when 'article'
      streams = [["Story_16c_Hero", "Hero"], ["Story_Narrative", "Narrative"], ["Story_Related", "Related"], ["Story_footer", "Footer"]]
    when 'data grid'
      streams = [["Data_16c_Hero", "Hero"], ["Data_Grid", "#{self.id}_Section_data"]]
    else
      streams = [["Data_16c_Hero", "Hero"], ["Data_Grid", "#{self.id}_Section_data"], ["Data_credits", "Credits"]]
    end
    streams.each do |s|
      stream = Stream.create!({
        col_name: "Page",
        col_id: self.id,
        site_id: self.site_id,
        folder_id: self.folder_id,
        created_by: self.created_by,
        updated_by: self.updated_by,
        title: "#{self.id}_#{s.first}",
        description: "#{self.id}-#{s.first} stream #{self.summary}"
      })

      page_stream = PageStream.create!({
        page_id: self.id,
        stream_id: stream.id,
        name_of_stream: s.last,
        created_by: self.created_by,
        updated_by: self.updated_by
      })
    end
    true
  end

  def after_save_set
      if self.template_page.name == 'Homepage: Vertical' and self.series.present?
        self.series.update_site_verticals
        self.series.update_columns(description: self.meta_description, keywords: self.meta_keywords)
      end
      if self.collaborator_lists.present?
          self.collaborator_lists = self.collaborator_lists.reject(&:empty?)
          prev_collaborator_ids = self.permissions.pluck(:user_id)
          self.collaborator_lists.each do |c|
              user = User.find(c)
              a = user.create_permission("Page", self.id, "contributor")
          end
          self.permissions.where(permissible_id: (prev_collaborator_ids - self.collaborator_lists.map{|a| a.to_i})).update_all(status: 'Deactivated')
      end
      if self.import_url.present?
        ArticleFetchWorker.perform_async(import_url, self.site.id, self.id)
      end
    end

end
