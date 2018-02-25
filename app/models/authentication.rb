# == Schema Information
#
# Table name: authentications
#
#  id                  :integer          not null, primary key
#  provider            :string(255)
#  uid                 :string(255)
#  info                :text(65535)
#  name                :string(255)
#  email               :string(255)
#  access_token        :string(255)
#  access_token_secret :string(255)
#  refresh_token       :string(255)
#  token_expires_at    :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :integer
#  site_id             :integer
#  created_by          :integer
#  updated_by          :integer
#  account_id          :integer
#

#TODO AMIT - Handle created_by, updated_by, account_id - RP added retrospectively. Need migration of old rows and BAU handling.

class Authentication < ApplicationRecord

  #CONSTANTS
  #CUSTOM TABLES
  #CONCERNS
  include Propagatable
  include AssociableByAcSi
  
  #ASSOCIATIONS
  belongs_to :user
  #ACCESSORS
  #VALIDATIONS
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, scope: :provider
  #CALLBACKS
  #SCOPE
  scope :fb_auth, -> {where provider: 'facebook'}
  scope :tw_auth, -> {where provider: 'twitter'}
  scope :insta_auth, -> {where provider: 'instagram'}
  #PRIVATE
  #OTHER

  def refresh_access_token
    if self.provider == 'facebook'
      if token_expired?
        refresh_token = RestClient.get 'https://graph.facebook.com/oauth/access_token', {
          params: {
            client_id: ENV['FACEBOOK_KEY'],
            client_secret: ENV['FACEBOOK_SECRET'],
            grant_type: 'fb_exchange_token',
            fb_exchange_token: self.access_token
            }
          }
        if refresh_token.code == 200
          response = JSON.parse(refresh_token)
          self.access_token = response['access_token']
          self.token_expires_at = Time.at(Time.now.to_i + response['expires_in'])
          self.save
        else
          # retry
          return refresh_access_token
        end
      end
    end
  end

  def token_expired?
    expiry = Time.at(self.token_expires_at)
    if expiry < Time.now # expired token, so we should quickly return
      return true
    else
      return false # token not expired. :D
    end
  end

end
