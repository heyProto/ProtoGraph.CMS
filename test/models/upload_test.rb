# == Schema Information
#
# Table name: uploads
#
#  id               :integer          not null, primary key
#  attachment       :string(255)
#  template_card_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class UploadTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
