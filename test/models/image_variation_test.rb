# == Schema Information
#
# Table name: image_variations
#
#  id               :integer          not null, primary key
#  image_id         :integer
#  image_url        :text(65535)
#  image_key        :text(65535)
#  image_width      :integer
#  image_height     :integer
#  thumbnail_url    :text(65535)
#  thumbnail_key    :text(65535)
#  thumbnail_width  :integer
#  thumbnail_height :integer
#  is_original      :boolean
#  created_by       :integer
#  updated_by       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class ImageVariationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
