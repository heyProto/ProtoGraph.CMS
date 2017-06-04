# == Schema Information
#
# Table name: datacast_accounts
#
#  id          :integer          not null, primary key
#  datacast_id :integer
#  account_id  :integer
#  is_active   :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class DatacastAccount < ApplicationRecord

    #CONSTANTS
    #CUSTOM TABLES
    #GEMS
    #ASSOCIATIONS
    belongs_to :datacast
    belongs_to :account

    #ACCESSORS
    #VALIDATIONS
    validates :datacast_id, presence: true
    validates :account_id, presence: true

    #CALLBACKS
    #SCOPE
    #OTHER
    #PRIVATE
    private


end
