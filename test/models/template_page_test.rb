# == Schema Information
#
# Table name: template_pages
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  description         :text(65535)
#  global_slug         :text(65535)
#  is_current_version  :boolean
#  slug                :string(255)
#  version_series      :string(255)
#  previous_version_id :integer
#  version_genre       :string(255)
#  version             :string(255)
#  change_log          :text(65535)
#  status              :string(255)
#  publish_count       :integer
#  is_public           :boolean
#  git_url             :string(255)
#  git_branch          :string(255)
#  git_repo_name       :string(255)
#  s3_identifier       :string(255)
#  created_by          :integer
#  updated_by          :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'test_helper'

class TemplatePageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
