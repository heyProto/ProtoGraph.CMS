# == Schema Information
#
# Table name: site_template_apps
#
#  id              :integer          not null, primary key
#  site_id         :integer
#  template_app_id :integer
#  status          :string
#  invited_at      :datetime
#  invited_by      :integer
#  created_by      :integer
#  updated_by      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class SiteTemplateApp < ApplicationRecord
end
