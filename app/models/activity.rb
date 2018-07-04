# == Schema Information
#
# Table name: activities
#
#  id             :bigint(8)        not null, primary key
#  user_id        :bigint(8)
#  action         :string(255)
#  trackable_id   :bigint(8)
#  trackable_type :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  folder_id      :bigint(8)
#  site_id        :bigint(8)
#  created_by     :bigint(8)
#  updated_by     :bigint(8)
#

#TODO AMIT - Handle created_by, updated_by - RP added retrospectively. Need migration of old rows and BAU handling.

class Activity < ApplicationRecord
  
  #GEMS
  #CONCERNS
  include AssociableBySiFo
  
  belongs_to :user
  belongs_to :trackable, polymorphic: true
end
