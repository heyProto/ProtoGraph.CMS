class ApiController < ApplicationController
    before_action :set_user_from_token, :set_global_objects

    def set_user_from_token
        access_token = request.headers["Access-Token"]
        @user = User.find_by_access_token(access_token)
        render_user_not_found if @user.nil?
    end

    def track_activity(trackable, action = params[:action])
    if @site.present?
      if @folder.present?
          @user.activities.create!(action: action, trackable: trackable, folder_id: @folder.id, site_id: @site.id)
      else
          @user.activities.create!(action: action, trackable: trackable, site_id: @site.id)
      end
    end
  end

    def set_global_objects
        if @user.present?
            @on_site_page = (@site.present? and @site.id.present?)
            if @on_site_page
                @permission = @user.owner_role(@site.id) || @user.permission_object(@site.id)
                if @permission.blank?
                    render_permission_not_found
                else
                    @permission_role = @permission.permission_role
                    @role = @permission.ref_role_slug
                    unless @permission_role.can_add_view_casts
                        render_cannot_add_view_casts
                    end
                end
            end
        end
    end

    def render_user_not_found
        render json: {
            error_message: t("user.not_found")
        }, status: 404 and return
    end

    def render_permission_not_found
        render json: {
            error_message: "Permission denied."
        }, status: 403 and return
    end

    def render_cannot_add_view_casts
        render json: {
            error_message: "Permission denied."
        }, status: 403 and return
    end

end