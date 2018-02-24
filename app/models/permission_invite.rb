# == Schema Information
#
# Table name: permission_invites
#
#  id               :integer          not null, primary key
#  permissible_id   :integer
#  email            :string(255)
#  ref_role_slug    :string(255)
#  created_by       :integer
#  updated_by       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  permissible_type :string(255)
#

class PermissionInvite < ApplicationRecord

    #CONSTANTS
    #CUSTOM TABLES
    #CONCERNS
    include AssociableBy
    include Propagatable
    
    #GEMS
    #ASSOCIATIONS
    belongs_to :permissible, polymorphic: true

    #ACCESSOR
    attr_accessor :redirect_url
    #VALIDATIONS
    validates :permissible_type, presence: true
    validates :permissible_id, presence: true
    validates :email, presence: true, format: { with: /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/ }
    validates :ref_role_slug, presence: true
    validate  :is_unique_row?, on: :create

    #CALLBACKS
    #SCOPE
    scope :account_permissions, -> { where(permissible_type: "Account") }
    scope :site_permissions, -> { where(permissible_type: "Site") }
    #OTHER
    #PRIVATE
    private

    def is_unique_row?
        errors.add(:email, "already invited.") if PermissionInvite.where(permissible_type: self.permissible_type, permissible_id: self.permissible_id, email: self.email).first.present?
        true
    end

end
