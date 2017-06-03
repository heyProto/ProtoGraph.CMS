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

require 'test_helper'

class DatacastAccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
