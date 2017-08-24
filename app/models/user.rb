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
    devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable #, :omniauthable

    #ASSOCIATIONS
    has_many :permissions, ->{where(status: "Active")}
    has_many :accounts, through: :permissions

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

    #SCOPE
    #OTHER

    def permission_object(accid, s="Active")
        Permission.where(user_id: self.id, account_id: accid, status: s).first
    end

    def is_admin_from_pykih
        ["ritvvij.parrikh@pykih.com", "rp@pykih.com", "ab@pykih.com", "dhara.shah@pykih.com"].index(self.email).present? ? true : false
    end

    def create_permission(accid, r)
        p = Permission.where(user_id: self.id, account_id: accid).first
        if p.present?
            p.update_attributes(status: "Active", ref_role_slug: r, updated_by: self.id)
        else
            Permission.create(user_id: self.id, account_id: accid, created_by: self.id, updated_by: self.id, ref_role_slug: r)
        end
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
    end

end
