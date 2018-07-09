# == Schema Information
#
# Table name: activities
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  action         :string(255)
#  trackable_id   :integer
#  trackable_type :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  folder_id      :integer
#  site_id        :integer
#  created_by     :integer
#  updated_by     :integer
#

#TODO AMIT - Handle created_by, updated_by - RP added retrospectively. Need migration of old rows and BAU handling.

class Activity < ApplicationRecord
  
  #GEMS
  #CONCERNS
  include AssociableBySiFo
  
  belongs_to :user
  belongs_to :trackable, polymorphic: true
end
