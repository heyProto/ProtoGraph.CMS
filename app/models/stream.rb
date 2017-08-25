# == Schema Information
#
# Table name: streams
#
#  id                  :integer          not null
#  title               :string(255)
#  slug                :string(255)      primary key
#  description         :text(65535)
#  folder_id           :integer
#  account_id          :integer
#  datacast_identifier :string(255)
#  created_by          :integer
#  updated_by          :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Stream < ApplicationRecord
    #CONSTANTS
    #CUSTOM TABLES
    self.primary_key = "slug"

    #GEMS
    include SearchCop
    extend FriendlyId
    friendly_id :name, use: :slugged

    search_scope :search do
        attributes :title, :description

        options :title, :type => :fulltext
        options :description, :type => :fulltext
    end


    #ASSOCIATIONS
    #ACCESSORS
    #VALIDATIONS
    #CALLBACKS
    #SCOPE
    #OTHER

    #PRIVATE
    private

end
