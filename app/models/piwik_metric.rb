# == Schema Information
#
# Table name: piwik_metrics
#
#  id                  :integer          not null, primary key
#  datacast_identifier :string(255)
#  module              :string(255)
#  metric              :string(255)
#  value               :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class PiwikMetric < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  belongs_to :view_cast, class_name: "ViewCast",
             foreign_key: "datacast_identifier", primary_key: "datacast_identifier"
  #ACCESSORS
  #VALIDATIONS
  #CALLBACKS
  #SCOPE
  #OTHER
  #PRIVATE
end
