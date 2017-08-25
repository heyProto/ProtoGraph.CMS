class Stream < ApplicationRecord
    #CONSTANTS
    #CUSTOM TABLES
    self.primary_key = "slug"

    #GEMS
    extend FriendlyId
    friendly_id :name, use: :slugged

    search_scope :search do
        attributes :title, :description

        options :title, :type => :fulltext
        options :author, :type => :fulltext
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
