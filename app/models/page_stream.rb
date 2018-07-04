# == Schema Information
#
# Table name: page_streams
#
#  id             :bigint(8)        not null, primary key
#  page_id        :bigint(8)
#  stream_id      :bigint(8)
#  created_by     :bigint(8)
#  updated_by     :bigint(8)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  name_of_stream :string(255)
#  site_id        :bigint(8)
#  folder_id      :bigint(8)
#

class PageStream < ApplicationRecord

  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #CONCERNS
  include Propagatable
  include AssociableBySiFo
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
