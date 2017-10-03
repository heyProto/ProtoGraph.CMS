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
#  account_id     :integer
#

class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :account
  belongs_to :folder, optional: true
  belongs_to :trackable, polymorphic: true
end
