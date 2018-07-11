# == Schema Information
#
# Table name: ad_integrations
#
#  id             :integer          not null, primary key
#  site_id        :integer
#  stream_id      :integer
#  page_id        :integer
#  sort_order     :integer
#  div_id         :string(255)
#  height         :integer
#  width          :integer
#  slot_text      :text
#  page_stream_id :integer
#  created_by     :integer
#  updated_by     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class AdIntegration < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #CONCERNS
  include AssociableBy
  #ASSOCIATIONS
  belongs_to :site
  belongs_to :stream, optional: true
  belongs_to :page_stream
  belongs_to :page
  #ACCESSORS
  #VALIDATIONS
  validates :sort_order, presence: true
  validates :div_id, presence: true
  #CALLBACKS
  before_create :before_create_set
  #SCOPE
  scope :ordered, ->{order(sort_order: :desc)}
  #OTHER

  def before_create_set
    self.stream_id = self.page_stream.stream_id
  end
  #PRIVATE
end
