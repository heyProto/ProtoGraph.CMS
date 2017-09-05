# == Schema Information
#
# Table name: accounts
#
#  id             :integer          not null, primary key
#  username       :string(255)
#  slug           :string(255)
#  domain         :string(255)
#  gravatar_email :string(255)
#  status         :string(255)
#  sign_up_mode   :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  cdn_provider   :string(255)
#  cdn_id         :string(255)
#  host           :text(65535)
#  cdn_endpoint   :text(65535)
#  client_token   :string(255)
#  access_token   :string(255)
#  client_secret  :string(255)
#  logo_image_id  :integer
#

class Account < ApplicationRecord

    #CONSTANTS
    SIGN_UP_MODES = ["Invitation only", "Any email from your domain"]

    #CUSTOM TABLES
    #GEMS
    extend FriendlyId
    friendly_id :username, use: :slugged
    mount_uploader :logo_url, ImageUploader

    #ASSOCIATIONS
    has_many :permissions, ->{where(status: "Active")}
    has_many :users, through: :permissions
    has_many :permission_invites
    has_many :authentications
    has_many :view_casts
    has_many :folders
    has_many :activities
    belongs_to :logo_image, class_name: "Image", foreign_key: "logo_image_id", primary_key: "id", optional: true
    accepts_nested_attributes_for :logo_image

    #ACCESSORS
    #VALIDATIONS
    validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { in: 3..24 }, format: { with: /\A[a-z0-9A-Z_]{4,16}\z/ }

    validates :domain, format: {:with => /[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}/ }, allow_blank: true, allow_nil: true, length: { in: 3..240 }, exclusion: { in: %w(gmail.com outlook.com yahoo.com mail.com),
    message: "%{value} is reserved." } #TODO AMIT - we need to think of more free email providers

    validates :gravatar_email, format: { with: /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/ }, allow_blank: true, allow_nil: true
    validates :cdn_endpoint, format: URI::regexp(%w(http https)), allow_nil: true
    #CALLBACKS
    before_create :before_create_set
    before_update :before_update_set
    after_save :after_save_set

    #SCOPE
    #OTHER

    def template_cards
        TemplateCard.where("account_id = ? OR is_public = true", self.id)
    end

    def template_data
        TemplateDatum.where("account_id = ? OR is_public = true", self.id)
    end

    #PRIVATE
    private

    def before_create_set
        self.slug = self.username
        self.sign_up_mode = "Invitation only"
        self.cdn_provider = "CloudFront"
        self.cdn_id = ENV['AWS_CDN_ID']
        self.host = "#{AWS_API_DATACAST_URL}/cloudfront/invalidate"
        self.cdn_endpoint = ENV['AWS_S3_ENDPOINT']
        self.client_token = ENV['AWS_ACCESS_KEY_ID']
        self.client_secret = ENV['AWS_SECRET_ACCESS_KEY']
        true
    end

    def before_update_set
        self.cdn_id = ENV['AWS_CDN_ID'] if self.cdn_id.blank? and self.cdn_endpoint == ENV['AWS_S3_ENDPOINT']
        self.host = "#{AWS_API_DATACAST_URL}/cloudfront/invalidate" if self.host.blank?
        self.cdn_endpoint = ENV['AWS_S3_ENDPOINT'] if self.cdn_endpoint.blank?
        self.client_token = ENV['AWS_ACCESS_KEY_ID'] if self.client_token.blank?
        self.client_secret = ENV['AWS_SECRET_ACCESS_KEY'] if self.client_secret.blank?
    end

    def after_save_set
    end

end
