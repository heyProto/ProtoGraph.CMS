# == Schema Information
#
# Table name: page_streams
#
#  id             :integer          not null, primary key
#  page_id        :integer
#  stream_id      :integer
#  created_by     :integer
#  updated_by     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  name_of_stream :string(255)
#  account_id     :integer
#  site_id        :integer
#  folder_id      :integer
#

#TODO AMIT - Handle account_id, site_id, folder_id - RP added retrospectively. Need migration of old rows and BAU handling.

class PageStream < ApplicationRecord

  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #CONCERNS
  include Propagatable
  include AssociableByAcSiFo
  #ASSOCIATIONS
  belongs_to :page
  belongs_to :stream
  has_many :ad_integrations
  #ACCESSORS
  #VALIDATIONS
  #CALLBACKS
  #SCOPE
  #OTHER

  def ad_integration_json
    obj = {}
    self.ad_integrations.order(:sort_order).each do |d|
      obj[d.sort_order] = d
    end
    obj
  end
  #PRIVATE
  private

end
