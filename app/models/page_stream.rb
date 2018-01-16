# == Schema Information
#
# Table name: page_streams
#
#  id         :integer          not null, primary key
#  page_id    :integer
#  stream_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PageStream < ApplicationRecord
    #CONSTANTS
    #CUSTOM TABLES
    #GEMS
    #ASSOCIATIONS
    belongs_to :stream
    belongs_to :page
    #ACCESSORS
    #VALIDATIONS
    #CALLBACKS
    #SCOPE
    #OTHER
    #PRIVATE
end
