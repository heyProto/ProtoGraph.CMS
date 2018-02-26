module Propagatable
    extend ActiveSupport::Concern

    included do
      after_commit :propogate_updated_at
    end

    private

    def propogate_updated_at
      if self.saved_changes.present?
        if ["ViewCast", "Stream"].index(self.class.to_s).present?
          self.folder.update_attributes(updated_at: Time.now)               if self.folder.present?
        elsif ["Page"].index(self.class.to_s).present?
          self.folder.update_attributes(updated_at: Time.now)               if self.folder.present?
          self.series.update_attributes(updated_at: Time.now)               if self.series.present?
          self.intersection.update_attributes(updated_at: Time.now)         if self.intersection.present?
          self.sub_intersection.update_attributes(updated_at: Time.now)     if self.sub_intersection.present?
        elsif self.class.to_s == "SiteVerticalNavigation"
          self.ref_category.update_attributes(updated_at: Time.now)         if self.ref_category.present?
        elsif ["Image", "Audio"].index(self.class.to_s).present?
          self.account.update_attributes(updated_at: Time.now)              if self.account.present?
        elsif ["RefCategory", "Folder"].index(self.class.to_s).present?
          self.site.update_attributes(updated_at: Time.now)                 if self.site.present?
        elsif ["PageStream", "PageTodo"].index(self.class.to_s).present?
          self.page.update_attributes(updated_at: Time.now)                 if self.page.present?
        elsif ["Site"].index(self.class.to_s).present?
          self.account.update_attributes(updated_at: Time.now)              if self.account.present?
        elsif ["UserEmail"].index(self.class.to_s).present?
          self.user.update_attributes(updated_at: Time.now)                 if self.user.present?
        elsif ["ImageVariation"].index(self.class.to_s).present?
          self.image.update_attributes(updated_at: Time.now)                if self.image.present?
        elsif ["AudioVariation"].index(self.class.to_s).present?
          self.audio.update_attributes(updated_at: Time.now)                if self.audio.present?
        elsif self.class.to_s == "Authentication" and self.user_id.present?
          self.user.update_attributes(updated_at: Time.now)                 if self.user.present?
        elsif self.class.to_s == "Authentication" and self.site_id.present?
          self.site.update_attributes(updated_at: Time.now)                 if self.site.present?
        end
      end
      true

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