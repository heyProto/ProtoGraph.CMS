# == Schema Information
#
# Table name: ad_integrations
#
#  id         :integer          not null, primary key
#  account_id :integer
#  site_id    :integer
#  stream_id  :integer
#  page_id    :integer
#  sort_order :integer
#  ad_id      :string(255)
#  div_id     :string(255)
#  height     :integer
#  width      :integer
#  slot_text  :text(65535)
#  created_by :integer
#  updated_by :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AdIntegration < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #CONCERNS
  include AssociableBy
  #ASSOCIATIONS
  belongs_to :account
  belongs_to :site
  belongs_to :stream
  belongs_to :page
  #ACCESSORS
  #VALIDATIONS
  validates :sort_order, presence: true
  validates :add_id, presence: true
  validates :div_id, presence: true
  #CALLBACKS
  #SCOPE
  scope :ordered, ->{order(sort_order: :desc)}
  #OTHER
  #PRIVATE
end
