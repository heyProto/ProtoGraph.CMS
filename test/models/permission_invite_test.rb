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

require 'test_helper'

class PermissionInviteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
