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
#

class Account < ApplicationRecord

    #CONSTANTS
    SIGN_UP_MODES = ["Invitation only", "Any email from your domain"]

    #CUSTOM TABLES
    #GEMS
    extend FriendlyId
    friendly_id :username, use: :slugged

    #ASSOCIATIONS
    has_many :permissions
    has_many :users, through: :permissions
    has_many :permission_invites
    has_many :authentications
    has_many :datacast_accounts
    has_many :datacasts, through: :datacast_accounts

    #ACCESSORS
    #VALIDATIONS
    validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { in: 3..24 }, format: { with: /\A[a-z0-9_]{4,16}\z/ }

    validates :domain, format: {:with => /[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}/ }, allow_blank: true, allow_nil: true, length: { in: 3..240 }, exclusion: { in: %w(gmail.com outlook.com yahoo.com mail.com),
    message: "%{value} is reserved." } #TODO - we need to think of more free email providers

    validates :gravatar_email, format: { with: /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/ }, allow_blank: true, allow_nil: true

    #CALLBACKS
    before_create :before_create_set

    #SCOPE
    #OTHER

    def template_cards
        TemplateCard.where("account_id = ? OR is_public = true", self.id)
    end

    def template_data
        TemplateDatum.where("account_id = ? OR is_public = true", self.id)
    end

    def template_streams
        TemplateStream.where("account_id = ? OR is_public = true", self.id)
    end

    def create_permission(uid, r)
        Permission.create(user_id: uid, account_id: self.id, created_by: uid, updated_by: uid, ref_role_slug: r)
    end

    #PRIVATE
    private

    def before_create_set
        self.slug = self.username
        self.sign_up_mode = "Invitation only"
        true
    end

end
