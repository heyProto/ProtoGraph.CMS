# == Schema Information
#
# Table name: accounts
#
#  id           :integer          not null, primary key
#  username     :string(255)
#  slug         :string(255)
#  domain       :string(255)
#  status       :string(255)
#  sign_up_mode :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Account < ApplicationRecord

    #CONSTANTS
    SIGN_UP_MODES = ["Invitation only", "Any email from your domain"]

    #CUSTOM TABLES
    #GEMS
    extend FriendlyId
    friendly_id :username, use: :slugged

    #ASSOCIATIONS
    has_many :permissions, ->{where(status: "Active")}, dependent: :destroy
    has_many :users, through: :permissions
    has_many :permission_invites, dependent: :destroy
    has_many :view_casts, dependent: :destroy
    has_many :folders, dependent: :destroy
    has_many :uploads, dependent: :destroy
    has_many :activities, dependent: :destroy
    has_many :images, dependent: :destroy
    has_many :uploads, dependent: :destroy
    has_many :audios, dependent: :destroy
    has_one :site,dependent: :destroy #change it to many later
    #ACCESSORS
    attr_accessor :coming_from_new
    #VALIDATIONS
    validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { in: 3..24 }, format: { with: /\A[a-z0-9A-Z_]{4,16}\z/ }

    validates :domain, format: {:with => /[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}/ }, allow_blank: true, allow_nil: true, length: { in: 3..240 }, exclusion: { in: %w(gmail.com outlook.com yahoo.com mail.com),
    message: "%{value} is reserved." } #TODO AMIT - we need to think of more free email providers
    validates :cdn_endpoint, format: URI::regexp(%w(http https)), allow_nil: true
    #CALLBACKS
    before_create :before_create_set
    before_update :before_update_set
    before_update :change_view_casts_house_colours, if: :house_colour_changed?
    after_create :after_create_set
    #SCOPE
    #OTHER

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

    def create_sudo_permission(role)
        pykih_admin = User.find_by(email: "ab@pykih.com")
        Permission.create(
          is_hidden: true,
          created_by: pykih_admin.id,
          updated_by: pykih_admin.id,
          account_id: self.id,
          user_id: pykih_admin.id,
          ref_role_slug: role
        )
    end

    #DEPENDENT DESTROY
    # Account.where(id: a).delete_all
    # Folder.where(account_id: a).delete_all
    # Permission.where(account_id: a).delete_all
    # PermissionInvite.where(account_id: a).delete_all
    # Image.where(account_id: a).delete_all
    # ImageVariation.where(account_id: a).delete_all
    # Audio.where(account_id: a).delete_all
    # AudioVariation.where(account_id: a).delete_all
    # Stream.where(account_id: a).delete_all
    # Site.where(account_id: a).delete_all
    # RefCategory.where(account_id: a).delete_all
    # Activity.where(account_id: a).delete_all

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
        # self.cdn_id = ENV['AWS_CDN_ID'] if self.cdn_id.blank? and self.cdn_endpoint == ENV['AWS_S3_ENDPOINT']
        # self.host = "#{AWS_API_DATACAST_URL}/cloudfront/invalidate" if self.host.blank?
        # self.cdn_endpoint = ENV['AWS_S3_ENDPOINT'] if self.cdn_endpoint.blank?
        # self.client_token = ENV['AWS_ACCESS_KEY_ID'] if self.client_token.blank?
        # self.client_secret = ENV['AWS_SECRET_ACCESS_KEY'] if self.client_secret.blank?
    end

    def change_view_casts_house_colours
        ColorUpdateWorker.perform_in(1.seconds, self.id)
    end

    def after_create_set
        Site.create({account_id: self.id, name: self.username, domain: self.domain})
        create_sudo_permission("owner")
    end
end
