# == Schema Information
#
# Table name: user_emails
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  email                :string(255)
#  confirmation_token   :string(255)
#  confirmation_sent_at :datetime
#  confirmed_at         :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  is_primary_email     :boolean
#

class UserEmail < ApplicationRecord

    #CONSTANTS
    #CUSTOM TABLES
    #GEMS
    #ASSOCIATIONS
    belongs_to :user

    #ACCESSORS
    #VALIDATIONS
    validates :email, presence: true
    validates :email, uniqueness: true
    validates_format_of :email, with: /\A\S+@.+\.\S+\z/, message: "Please enter a valid email address"
    #CALLBACKS
    #SCOPE
    #OTHER
    #PRIVATE
end
