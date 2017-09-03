# == Schema Information
#
# Table name: articles
#
#  id                         :integer          not null, primary key
#  account_id                 :integer
#  folder_id                  :integer
#  cover_image_id             :integer
#  title                      :string(255)
#  summary                    :text(65535)
#  content                    :text(65535)
#  genre                      :string(255)
#  og_image_variation_id      :text(65535)
#  og_image_width             :integer
#  og_image_height            :integer
#  twitter_image_variation_id :text(65535)
#  created_by                 :integer
#  updated_by                 :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  url                        :text(65535)
#  slug                       :string(255)
#

class Article < ApplicationRecord
    #CONSTANTS

    #ASSOCIATIONS
    belongs_to :folder
    has_one :cover_image, class_name: "Image", primary_key: "cover_image_id", foreign_key: "id"
    has_one :twitter_image_variation, class_name: "ImageVariation", foreign_key: "twitter_image_variation_id"
    has_one :og_image_variation, class_name: "ImageVariation", foreign_key: "og_image_variation_id"
    #GEMS
    include Associable
    extend FriendlyId
    friendly_id :title, use: :slugged
    accepts_nested_attributes_for :cover_image

    #ACCESSORS
    #VALIDATIONS
    #CALLBACKS

    #SCOPE
    #OTHER

    def should_generate_new_friendly_id?
        title_changed?
    end

    def cover_image_variation
        cover_image.original_image
    end

    #PRIVATE
    private


end
