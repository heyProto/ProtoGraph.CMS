# == Schema Information
#
# Table name: ref_tags
#
#  id         :integer          not null, primary key
#  site_id    :integer
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class RefTag < ApplicationRecord
    #CONSTANTS
    #CUSTOM TABLES
    #GEMS
    #ASSOCIATIONS
    belongs_to :site
    #ACCESSORS
    #VALIDATIONS
    validates :name, presence: true, uniqueness: true
    #CALLBACKS
    #SCOPE
    #OTHER
    #PRIVATE
    private
end
