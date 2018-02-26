# == Schema Information
#
# Table name: page_todos
#
#  id               :integer          not null, primary key
#  page_id          :integer
#  user_id          :integer
#  template_card_id :integer
#  task             :text(65535)
#  is_completed     :boolean
#  sort_order       :integer
#  created_by       :integer
#  updated_by       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  account_id       :integer
#  site_id          :integer
#  folder_id        :integer
#

#TODO AMIT - Handle account_id, site_id, folder_id - RP added retrospectively. Need migration of old rows and BAU handling.

class PageTodo < ApplicationRecord
  
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #CONCERNS
  include Propagatable
  include AssociableByAcSiFo
  #ASSOCIATIONS
  belongs_to :page
  belongs_to :user, optional: true
  belongs_to :template_card, optional: true  
  #ACCESSORS
  #VALIDATIONS
  validates :page_id, presence: true
  validates :task, presence: true
  
  #CALLBACKS
  before_create :before_create_set
  
  #SCOPE
  #OTHER
  #PRIVATE
  private
  
  def before_create_set
    self.is_completed = false
    final = PageTodo.where(page_id: self.page_id).order("sort_order DESC").first
    self.sort_order = final.blank? ? 1 : (final.sort_order + 10)
    true
  end
  
end
