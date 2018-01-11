# == Schema Information
#
# Table name: site_view_casts
#
#  id           :integer          not null, primary key
#  site_id      :integer
#  view_cast_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class SiteViewCast < ApplicationRecord
    #CONSTANTS
    #CUSTOM TABLES
    #GEMS
    #ASSOCIATIONS
    belongs_to :site
    belongs_to :view_cast
    #ACCESSORS
    #VALIDATIONS
    #CALLBACKS
    #SCOPE
    #OTHER
    #PRIVATE
end
