# == Schema Information
#
# Table name: ref_roles
#
#  id                          :integer          not null
#  name                        :string(255)
#  slug                        :string(255)      primary key
#  can_account_settings        :boolean
#  can_template_design_do      :boolean
#  can_template_design_publish :boolean
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#

require 'test_helper'

class RefRoleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
