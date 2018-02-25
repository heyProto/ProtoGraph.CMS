module Propagatable
    extend ActiveSupport::Concern
    
    included do
      after_commit :propogate_updated_at
    end
    
    private
    
    def propogate_updated_at
      if self.class.to_s == "UserEmail" or (self.class.to_s == "Authentication" and self.user_id.present?)
        if self.saved_changes.present?
          self.user.updated_at = Time.now
        end
      end
      true
      
      # ["Image", "Audio", "RefCategory", "Folder", "Authentication"] --> SITE
      # ["Site"] --> ACCOUNT
      # ["UserEmail", "Authentication"] --> USER
      # ["PageStream", "PageTodo", "SiteVerticalNavigation"] --> PAGE
      # ["ImageVariation"] --> IMAGE
      # ["AudioVariation"] --> AUDIO
      # ["Page"] --> REF_CATEGORY
      # ["ViewCast", "Page", "Stream"] --> FOLDER
      
      
      #TODO AMIT - How do we handle this for Permission and PermissionInvite
      #-----------
      #This is not applicable for following models - 
       # ref_link_source
       # user
       # permission_role
       # colour_swatch
       # stream_entity
       # activity
       # template_datum
       # template_card
       # template_page
       # upload
      #-----------
    end
    
end