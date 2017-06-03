# == Schema Information
#
# Table name: authentications
#
#  id                  :integer          not null, primary key
#  account_id          :integer
#  provider            :string(255)
#  uid                 :string(255)
#  info                :text(65535)
#  name                :string(255)
#  email               :string(255)
#  access_token        :string(255)
#  access_token_secret :string(255)
#  refresh_token       :string(255)
#  token_expires_at    :datetime
#  created_by          :integer
#  updated_by          :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'test_helper'

class AuthenticationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
