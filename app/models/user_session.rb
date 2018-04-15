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
#  latitude         :string(255)
#  longitude        :string(255)
#  time_zone        :string(255)
#  zip_code         :string(255)
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
                unless a.ip == ip
                    a.ip = ip
                    begin
                        res = Geocoder.search(ip)
                        if res and res[0]
                            data = res[0].data
                            a.location_country = data["country_name"]
                            a.location_state = data["region_name"]
                            a.location_city = data["city"]
                            a.time_zone = data["time_zone"]
                            a.latitude = data["latitude"]
                            a.longitude = data["longitude"]
                        end
                    rescue => e
                    end
                end
            else
                a.ip = ip
            end
            a.user_id = user_id
            a.user_agent = user_agent
            a.save
        end
    end
    #PRIVATE
end
