# == Schema Information
#
# Table name: user_sessions
#
#  id               :integer          not null, primary key
#  session_id       :string(255)
#  user_id          :integer
#  ip               :string(255)
#  user_agent       :string(255)
#  location_city    :string(255)
#  location_state   :string(255)
#  location_country :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class UserSession < ApplicationRecord

    #CONSTANTS
    #CUSTOM TABLES
    #GEMS
    #CONCERNS
    #ASSOCIATIONS
    belongs_to :user
    #ACCESSORS
    #VALIDATIONS
    #CALLBACKS
    #SCOPE
    #OTHER

    class << self
        def log(session_id, user_id, ip, user_agent)
            a = where(session_id: session_id).first
            if a.blank?
              a = UserSession.new(session_id: session_id)
            end
            a.user_id = user_id
            a.ip = ip
            a.user_agent = user_agent
            a.save
        end
    end
    #PRIVATE
end
