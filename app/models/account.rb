# == Schema Information
#
# Table name: accounts
#
#  id            :integer          not null, primary key
#  username      :string(191)
#  slug          :string(191)
#  status        :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  cdn_provider  :string(255)
#  cdn_id        :string(255)
#  host          :text(65535)
#  cdn_endpoint  :text(65535)
#  client_token  :string(255)
#  access_token  :string(255)
#  client_secret :string(255)
#

class Account < ApplicationRecord

    #CONSTANTS
    #CUSTOM TABLES
    #GEMS
    extend FriendlyId
    friendly_id :username, use: :slugged
    #CONCERNS
    #ASSOCIATIONS
    has_many :permissions, ->{where(status: "Active", permissible_type: 'Account')}, foreign_key: "permissible_id", dependent: :destroy
    has_many :users, through: :permissions
    has_many :permission_invites, ->{where(permissible_type: 'Account')}, foreign_key: "permissible_id", dependent: :destroy
    has_many :view_casts, dependent: :destroy
    has_many :folders, dependent: :destroy
    has_many :uploads, dependent: :destroy
    has_many :activities, dependent: :destroy
    has_many :images, dependent: :destroy
    has_many :uploads, dependent: :destroy
    has_many :streams, dependent: :destroy
    has_one :site,dependent: :destroy #change it to many later

    #ACCESSORS
    attr_accessor :coming_from_new, :site_name, :domain
    #VALIDATIONS
    validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { in: 3..20 }, format: { with: /\A[a-z0-9A-Z]{4,20}\z/ }
    validates :site_name, presence: true, length: { in: 3..24 }, on: :create
    validates :cdn_endpoint, format: URI::regexp(%w(http https)), allow_nil: true
    validates :domain, format: {:with => /[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}/ }, allow_blank: true, allow_nil: true, length: { in: 3..240 }, exclusion: { in: %w(gmail.com outlook.com yahoo.com mail.com),message: "%{value} is reserved."}
    #CALLBACKS
    before_create :before_create_set
    after_create :after_create_set
    #SCOPE
    #OTHER

    def cdn_bucket
        if Rails.env.production?
            "account-#{self.slug.downcase.gsub("_", "")}-#{self.id}"
        else
            "dev.cdn.protograph"
        end
    end

    def template_cards
        if self.username == 'pykih'
            TemplateCard.all
        else
            TemplateCard.where("account_id = ? OR is_public = true", self.id)
        end
    end

    def template_data
        TemplateDatum.where("account_id = ? OR is_public = true", self.id)
    end

    #DEPENDENT DESTROY
    # Account.where(id: a).delete_all
    # Folder.where(account_id: a).delete_all
    # Permission.where(account_id: a).delete_all
    # PermissionInvite.where(account_id: a).delete_all
    # Image.where(account_id: a).delete_all
    # ImageVariation.where(account_id: a).delete_all
    # Stream.where(account_id: a).delete_all
    # Site.where(account_id: a).delete_all
    # RefCategory.where(account_id: a).delete_all
    # Activity.where(account_id: a).delete_all

    #PRIVATE
    private

    def before_create_set
        self.slug = self.username
        self.cdn_provider = "CloudFront"
        self.host = "#{AWS_API_DATACAST_URL}/cloudfront/invalidate"
        self.client_token = ENV['AWS_ACCESS_KEY_ID']
        self.client_secret = ENV['AWS_SECRET_ACCESS_KEY']
        true
    end

    def after_create_set
        site = Site.create({account_id: self.id, name: self.site_name, domain: self.domain})
        if Rails.env.production?
            resp = Api::ProtoGraph::Site.create_bucket_and_distribution(self.cdn_bucket)
            self.update_columns(
                cdn_id: resp['cloudfront_response']['Distribution']['Id'],
                cdn_endpoint: "https://#{resp['cloudfront_response']['Distribution']['DomainName']}"
            )
        else
            self.update_columns(
                cdn_id: ENV["AWS_CDN_ID"],
                cdn_endpoint: ENV['AWS_S3_ENDPOINT']
            )
        end
    end

end
