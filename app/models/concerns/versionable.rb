module Versionable
    extend ActiveSupport::Concern

    def parent
        self.class.where(global_slug: self.global_slug, is_current_version: true).first
    end

    def previous
       self.class.where(global_slug: self.global_slug, id: self.previous_version_id).first
    end

    def siblings
        self.class.where(global_slug: self.global_slug).order("version DESC")
    end

    def flip_public_private
        if self.is_public
            if self.can_make_private?
                self.update_attributes(is_public: false)
                return "Successfully done."
            else
                return "Failed. Some other account is using this card."
            end
        else
            if self.can_make_public?
                self.update_attributes(is_public: true)
                return "Successfully done."
            else
                return "Failed. Make sure card is published and associated data is public."
            end
        end
    end

    def move_to_next_status
        if self.can_ready_to_publish?
            self.update_attributes(status: "Ready to Publish")
            return "Successfully updated."
        elsif self.status == "Ready to Publish"
            self.update_attributes(status: "Published")
            return "Successfully updated."
        else
            return "Failed"
        end
    end

    def can_make_private?
        true
        #self.cards.where("account_id != ?", self.account_id).first.present? ? false : true
    end

    def can_make_public?
        self.status == "Published" ? true : false
    end

end