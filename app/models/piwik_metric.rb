# == Schema Information
#
# Table name: piwik_metrics
#
#  id                  :integer          not null, primary key
#  datacast_identifier :string(255)
#  piwik_module        :string(255)
#  piwik_metric_name   :string(255)
#  piwik_metric_value  :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  piwik_metric_type   :string(255)
#

# https://developer.piwik.org/api-reference/reporting-api
# piwik_module: type of api module, eg: Events, VisitsSummary, CustomDimensions, etc
# piwik_metric_name: name of metric from a given module, eg: visits, actions, unique_visitors, etc
# piwik_metric_type: optional, for use in case of additional information like type of browser, type of device, time durations, etc
# piwik_metric_value: numeric values like total amount of time on page, etc


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
