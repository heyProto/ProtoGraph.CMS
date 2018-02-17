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
  #ACCESSORS
  #VALIDATIONS
  #CALLBACKS
  #SCOPE
  #OTHER
  #PRIVATE
  private
  
end
