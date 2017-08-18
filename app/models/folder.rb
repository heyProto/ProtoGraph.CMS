# == Schema Information
#
# Table name: folders
#
#  id         :integer          not null, primary key
#  account_id :integer
#  name       :string(255)
#  slug       :string(255)
#  created_by :integer
#  updated_by :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Folder < ApplicationRecord
end
