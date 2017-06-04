# == Schema Information
#
# Table name: accounts
#
#  id         :integer          not null, primary key
#  username   :string(255)
#  slug       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  domain     :string(255)
#

class Account < ApplicationRecord

    #CONSTANTS
    #CUSTOM TABLES
    #GEMS
    extend FriendlyId
    friendly_id :username, use: :slugged

    #ASSOCIATIONS
    has_many :permissions
    has_many :users, through: :permissions
    has_many :permission_invites
    has_many :authentications

    #ACCESSORS
    #VALIDATIONS
    validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { in: 3..24 }, format: { with: /\A[a-z0-9_]{4,16}\z/ }
    validates :domain, format: {:with => /[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}/ }, allow_blank: true, length: { in: 3..240 }


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

    def create_permission(uid)
        Permission.create(user_id: uid, account_id: self.id, created_by: uid, updated_by: uid)
    end

    #PRIVATE
    private

    def before_create_set
        self.slug = self.username
        true
    end


end
