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
#

class PageTodo < ApplicationRecord
  
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  belongs_to :page
  belongs_to :user, optional: true
  belongs_to :creator, class_name: "User", foreign_key: "created_by"
  belongs_to :updator, class_name: "User", foreign_key: "updated_by"
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
