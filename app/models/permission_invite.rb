# == Schema Information
#
# Table name: permission_invites
#
#  id         :integer          not null, primary key
#  account_id :integer
#  email      :string(255)
#  created_by :integer
#  updated_by :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PermissionInvite < ApplicationRecord

    #CONSTANTS
    #CUSTOM TABLES
    #GEMS
    #ASSOCIATIONS
    belongs_to :account
    belongs_to :creator, class_name: "User", foreign_key: "created_by"
    belongs_to :updator, class_name: "User", foreign_key: "updated_by"

    #ACCESSORS
    #VALIDATIONS
    validates :account_id, presence: true
    validates :email, presence: true, format: { with: /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/ }
    validate  :is_unique_row?, on: :create

    #CALLBACKS
    #SCOPE
    #OTHER
    #PRIVATE
    private

    def is_unique_row?
        errors.add(:email, "already invited.") if PermissionInvite.where(account_id: self.account_id, email: self.email).first.present?
        true
    end

end
