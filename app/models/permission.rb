# == Schema Information
#
# Table name: permissions
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  account_id :integer
#  created_by :integer
#  updated_by :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
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

    #ACCESSORS
    #VALIDATIONS
    validates :user_id, presence: true
    validates :account_id, presence: true
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
