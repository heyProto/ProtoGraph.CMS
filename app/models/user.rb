# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)      default(""), not null
#  email                  :string(255)      default(""), not null
#  access_token           :string(255)
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ApplicationRecord

    #CONSTANTS
    #CUSTOM TABLES
    #GEMS
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:twitter]

    #ASSOCIATIONS
    has_many :permissions, ->{where(status: "Active")}
    has_many :accounts, through: :permissions
    has_many :activities
    has_many :uploads
    has_many :user_emails
    has_many :authentications
    #ACCESSORS
    attr_accessor :username

    #VALIDATIONS
    validates :name, presence: true, length: { in: 3..24 }
    validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/ }
    validates :username, presence: true, length: { in: 3..24 }, format: { with: /\A[a-z0-9A-Z_]{4,16}\z/ }, on: :create
    validate  :is_username_unique, on: :create
    #CALLBACKS
    before_create :before_create_set
    after_create :after_create_set
    after_create :welcome_user
    after_commit :add_user_email, on: [:create]
    #SCOPE
    scope :online, -> { where('updated_at > ?', 10.minutes.ago) }
    #OTHER

    def permission_object(accid, s="Active")
        Permission.where(user_id: self.id, account_id: accid, status: s).first
    end

    def is_admin_from_pykih
        ["ritvvij.parrikh@pykih.com", "rp@pykih.com", "ab@pykih.com", "dhara.shah@pykih.com", "aashutosh.bhatt@pykih.com"].index(self.email).present? ? true : false
    end

    def create_permission(accid, r)
        p = Permission.where(user_id: self.id, account_id: accid).first
        if p.present?
            p.update_attributes(status: "Active", ref_role_slug: r, updated_by: self.id, is_hidden: false)
        else
            Permission.create(user_id: self.id, account_id: accid, created_by: self.id, updated_by: self.id, ref_role_slug: r)
        end
    end

    def self.from_omniauth(auth)
      authentication = Authentication.where(:provider => auth.provider,
                                            :uid => auth.uid.to_s,
                                            :access_token => auth.credentials.token,
                                            :access_token_secret => auth.credentials.secret).first_or_initialize
      if authentication.user.blank?
        user = User.find_by(email: auth["info"]["email"])
        if user.present?
          authentication.user = user
          authentication.save
          return user
        end
        user = User.new
        user.email = auth['info']['email']
        user.name = auth["info"]["name"]
        user.username = auth["info"]["nickname"] || auth["info"]["name"]
        user.skip_confirmation!
        user.password = Devise.friendly_token[0, 20]
        user.fetch_details(auth)
        user.save
        authentication.user = user
        authentication.save
      end
      authentication.user
    end

    def fetch_details(auth)
      self.name = auth.info.name
      self.email = auth.info.email
    end

    def online?
      updated_at > 10.minutes.ago
    end

    def add_user_email
      # All user emails are handled by UserEmail model.
      # The user_email created with the same email as
      # the user is created with is primary email
      UserEmail.create(
        user_id: self.id,
        email: self.email,
        confirmed_at: Time.now,
        is_primary_email: 1
      )
    end
    #PRIVATE
    private

    def is_username_unique
        errors.add(:username, "already taken") if Account.where(username: self.username).first.present?
    end

    def before_create_set
        self.access_token = SecureRandom.hex(24)
    end

    def after_create_set
        a = Account.create(username: self.username)
        self.create_permission(a.id, "owner")
        folder = Folder.create({
            account_id: a.id,
            name: "Sample Project",
            created_by: self.id,
            updated_by: self.id
        })
        folder = Folder.create({
            account_id: a.id,
            name: "Recycle Bin",
            created_by: self.id,
            updated_by: self.id,
            is_trash: true,
            is_system_generated: true
        })
    end

    def welcome_user
        if Rails.env == "production"
            WelcomeUserWorker.perform_in(1.second, self.id)
        end
    end
end
