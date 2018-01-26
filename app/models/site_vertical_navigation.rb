# == Schema Information
#
# Table name: site_vertical_navigations
#
#  id                       :integer          not null, primary key
#  site_id                  :integer
#  ref_category_vertical_id :integer
#  name                     :string(255)
#  url                      :text(65535)
#  launch_in_new_window     :boolean
#  created_by               :integer
#  updated_by               :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  sort_order               :integer
#

class SiteVerticalNavigation < ApplicationRecord
  
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  belongs_to :site
  belongs_to :ref_category, class_name: "RefCategory", foreign_key: "ref_category_vertical_id"
  belongs_to :creator, class_name: "User", foreign_key: "created_by"
  belongs_to :updator, class_name: "User", foreign_key: "updated_by"  

  #ACCESSORS
  validates :name, presence: true
  validates :url, presence: true, format: {:with => /[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}/ }, allow_blank: true, allow_nil: true, length: { in: 3..240 }

  #CALLBACKS
  before_create :before_create_set
  
  #SCOPE
  #OTHER
  #PRIVATE
  
  def before_create_set
    self.launch_in_new_window = false if self.launch_in_new_window.blank?
    final = SiteVerticalNavigation.where(site_id: self.site_id, ref_category_vertical_id: self.ref_category_vertical_id).order("sort_order DESC").limit(1)
    if final.blank?
      self.sort_order = 1
    else
      self.sort_order = final.sort_order + 10
    end
    true
  end
  
end
