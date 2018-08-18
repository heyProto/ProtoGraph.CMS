# == Schema Information
#
# Table name: template_apps
#
#  id                     :integer          not null, primary key
#  site_id                :integer
#  name                   :string
#  genre                  :string
#  pitch                  :string
#  description            :text
#  is_public              :boolean
#  installs               :integer
#  views                  :integer
#  change_log             :text
#  git_url                :text
#  is_system_installed    :boolean
#  created_by             :integer
#  updated_by             :integer
#  is_backward_compatible :boolean          default(FALSE)
#  publish_count          :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  slug                   :string
#

class TemplateApp < ApplicationRecord
    #CONSTANTS
    #CUSTOM TABLES
    #GEMS
    extend FriendlyId
    friendly_id :name, use: :slugged

    #CONCERNS
    include AssociableBySi
    #ASSOCIATIONS
    has_one :template_datum
    has_one :template_card
    has_one :template_page
    
    def template
      if self.genre == "card"
        return self.template_card
      elsif self.genre == "datum"
        return self.template_datum
      elsif self.genre == "page"
        return self.template_page
      end
    end
    
    #ACCESSORS
    #VALIDATIONS
    #CALLBACKS
    before_create :before_create_set
    #SCOPE
    #OTHER
    #PRIVATE
    def before_create_set
        self.publish_count = 0
        true
    end


end
