# == Schema Information
#
# Table name: articles
#
#  id                           :integer          not null, primary key
#  account_id                   :integer
#  folder_id                    :integer
#  cover_image_id               :integer
#  title                        :string(255)
#  summary                      :text(65535)
#  content                      :text(65535)
#  genre                        :string(255)
#  og_image_variation_id        :text(65535)
#  og_image_width               :integer
#  og_image_height              :integer
#  twitter_image_variation_id   :text(65535)
#  created_by                   :integer
#  updated_by                   :integer
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  url                          :text(65535)
#  slug                         :string(255)
#  instagram_image_variation_id :integer
#  author                       :string(255)
#  article_datetime             :datetime
#  view_cast_id                 :integer
#  default_view                 :string(255)
#

class Article < ApplicationRecord
    #CONSTANTS
    ENABLED_MODES = {
        "11": ["Thumbnail with summary", "Thumbnail without summary", "Cover with summary","Text only with summary","Text only without summary"],
        "10": ["Thumbnail without summary"],
        "01": ["Text only with summary"],
        "00": ["Text only without summary"]
    }

    #ASSOCIATIONS
    belongs_to :folder
    belongs_to :cover_image, class_name: "Image", optional: true
    has_one :twitter_image_variation, class_name: "ImageVariation", primary_key: "twitter_image_variation_id", foreign_key: "id"
    has_one :og_image_variation, class_name: "ImageVariation", primary_key: "og_image_variation_id", foreign_key: "id"
    has_one :instagram_image_variation, class_name: "ImageVariation", primary_key: "instagram_image_variation_id", foreign_key: "id"
    has_one :article_card, class_name: "ViewCast", primary_key: "view_cast_id", foreign_key: "id"
    #GEMS
    include Associable
    extend FriendlyId
    friendly_id :title, use: :slugged
    accepts_nested_attributes_for :cover_image


    #ACCESSORS
    #VALIDATIONS
    validates :genre, length: {maximum: 40}
    validates :content, length: {maximum: 300}
    #CALLBACKS
    before_update :before_update_set
    after_save :publish_card

    #SCOPE
    #OTHER

    def cover_image_variation
        cover_image.original_image
    end

    def publish_card
        if self.article_card.present?
            view_cast = self.article_card
            view_cast.update({name: self.title, updated_by: self.updated_by, seo_blockquote: "<blockquote><h4#>#{self.title}</h4><p>#{self.content}</p></blockquote>", folder_id: self.folder_id})
        else
            view_cast = ViewCast.create({name: self.title,template_card_id: TemplateCard.where(name: 'toArticle').first.id,template_datum_id: TemplateDatum.where(name: 'toArticle').first.id, optionalConfigJSON: {"house_colour": self.account.house_colour}, created_by: self.created_by, updated_by: self.updated_by, seo_blockquote: "<blockquote><h4#>#{self.title}</h4><p>#{self.content}</p></blockquote>", folder_id: self.folder_id, default_view: "title_text", account_id: self.account_id})
        end
        payload = {}
        payload["payload"] = create_datacast_json.to_json
        payload["api_slug"] = view_cast.datacast_identifier
        payload["schema_url"] = view_cast.template_datum.schema_json
        payload["source"] = "form"
        if self.view_cast_id.present?
            r = Api::ProtoGraph::Datacast.update(payload)
        else
            r = Api::ProtoGraph::Datacast.create(payload)
            self.update_column(:view_cast_id, view_cast.id)
        end
        if self.account.cdn_id != ENV['AWS_CDN_ID']
            Api::ProtoGraph::CloudFront.invalidate(@account, ["/#{view_cast.datacast_identifier}/data.json","/#{view_cast.datacast_identifier}/view_cast.json"], 2)
        end
        Api::ProtoGraph::CloudFront.invalidate(nil, ["/#{view_cast.datacast_identifier}/*"], 1)
    end


    def create_datacast_json
        data = {"data" => {}}
        data["data"]["title"] = self.title.to_s
        data["data"]["url"] = self.url.to_s
        data["data"]["genre"] = self.genre.to_s
        data["data"]["feature_image_url"] = "#{self.instagram_image_variation.present? ? self.instagram_image_variation.image_url : ""}"
        data["data"]["thumbnail_url"] = "#{(self.cover_image.present? and self.cover_image.id.present?) ? self.cover_image.original_image.image_url : ""}"
        data["data"]["description"] = self.content.to_s
        data["data"]["author"] = "#{self.author}"
        data["data"]["date"] = self.article_datetime.strftime("%Y-%m-%dT%l:%M:%S%z")
        data
    end

    #PRIVATE
    private

    def before_update_set
        if self.cover_image_id_changed? and self.cover_image_id.nil?
            self.twitter_image_variation_id = nil
            self.og_image_variation_id = nil
            self.instagram_image_variation_id = nil
        end
    end

end
