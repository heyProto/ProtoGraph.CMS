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
                return "Failed. Some other site is using this card."
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
        if self.can_ready_to_publish? and self.status != 'Ready to Publish'
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
    end

    def can_make_public?
        self.status == "Published" ? true : false
    end

    def override_previous
        self.previous.view_casts.update_all(template_card_id: self.id)
    end

    def bump_version(mode)
        new_version = self.version.to_version
        new_version.bump!(mode.to_sym)
        vesion = self.class.create({
            site_id: self.site_id,
            name: self.name,
            elevator_pitch: self.elevator_pitch,
            description: self.description,
            global_slug: self.global_slug,
            version_series: new_version.major,
            previous_version_id: self.id,
            version_genre: mode,
            version: new_version,
            git_url: self.git_url,
            git_branch: new_version,
            template_datum_id: self.template_datum_id,
            has_static_image: self.has_static_image,
            git_repo_name: self.git_repo_name
        })
        if self.mode == 'bug'
            vesion.override_previous
        end
    end

end