# == Schema Information
#
# Table name: permissions
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  account_id    :integer
#  ref_role_slug :string(255)
#  created_by    :integer
#  updated_by    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Permission < ApplicationRecord

    #CONSTANTS
    #CUSTOM TABLES
    #GEMS
    #ASSOCIATIONS
    belongs_to :user
    belongs_to :account
    belongs_to :creator, class_name: "User", foreign_key: "created_by"
    belongs_to :updator, class_name: "User", foreign_key: "updated_by"
    belongs_to :ref_role, class_name: "RefRole", foreign_key: "ref_role_slug", primary_key: "slug"

    #ACCESSORS
    #VALIDATIONS
    validates :user_id, presence: true
    validates :account_id, presence: true
    validates :ref_role_slug, presence: true
    validate  :is_unique_row?, on: :create

    #CALLBACKS
    #SCOPE
    #OTHER
    #PRIVATE
    private

    def is_unique_row?
        errors.add(:user_id, "already invited.") if Permission.where(account_id: self.account_id, user_id: self.user_id).first.present?
        true
    end


end
