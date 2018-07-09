class ApplicationController < ActionController::Base
  before_action :log_additional_data
  protect_from_forgery with: :exception, unless: :json_request?
  protect_from_forgery with: :null_session, if: :json_request?
  before_action :log_user_session
  before_action :sudo
  after_action :user_activity

  def json_request?
    request.format.json?
  end

  def sudo_pykih_admin
    redirect_to root_url, notice: "Permission denied." unless current_user.is_admin_from_pykih and return
  end

  def sudo_role_can_site_settings
    redirect_to site_path(@site), notice: "Permission denied" unless @permission_role.can_change_site_settings and return
  end

  def sudo_role_can_add_site_people
    redirect_to site_path(@site), notice: "Permission denied" unless @permission_role.can_add_site_people and return
  end

  def sudo_role_can_add_site_categories
    redirect_to site_path(@site), notice: "Permission denied" unless @permission_role.can_add_site_categories and return
  end

  def sudo_role_can_disable_site_categories
    redirect_to site_path(@site), notice: "Permission denied" unless @permission_role.can_disable_site_categories and return
  end

  def sudo_role_can_folder_settings
    redirect_to site_path(@site), notice: "Permission denied" unless @permission_role.can_add_folder_people and return
  end

  def sudo_role_can_add_site_tags
    redirect_to site_path(@site), notice: "Permission denied" unless @permission_role.can_add_site_tags and return
  end

  def sudo_can_see_all_folders
    if !@permission_role.can_see_all_folders and @folder.users.pluck(:user_id).uniq.exclude?(current_user.id)
      redirect_to site_path(@site), notice: "Permission denied" and return
    end
  end

  def sudo_can_see_all_view_casts
    if !@permission_role.can_see_all_view_casts and @view_cast.users.pluck(:user_id).uniq.exclude?(current_user.id)
      redirect_to site_path(@site), notice: "Permission denied" and return
    end
  end

  def sudo_can_see_all_pages
    if !@permission_role.can_see_all_pages and @page.users.pluck(:user_id).uniq.exclude?(current_user.id)
      redirect_to site_path(@site), notice: "Permission denied" and return
    end
  end

  def sudo_can_see_all_streams
    if !@permission_role.can_see_all_streams and @stream.users.pluck(:user_id).uniq.include?(current_user.id)
      redirect_to site_path(@site), notice: "Permission denied" and return
    end
  end

  def sudo_role_can_template_designer
    redirect_to root_url, notice: "Permission denied" and return
  end

  def user_activity
    current_user.try :touch
  end

  private

  def sudo
    puts "params #{params}"
    if params[:site_id].present?
      @site = Site.friendly.find(params[:site_id])
      if params[:folder_id].present?
        @folder = @site.folders.friendly.find(params[:folder_id])
      elsif controller_name == "folders" and params[:id].present?
        @folder = @site.folders.friendly.find(params[:id])
      end
    elsif (controller_name == "sites" or controller_name == 'ref_categories') and params[:id].present?
      @site = Site.friendly.find(params[:id])
    end
    puts "application_controller:site=#{@site}"
    if user_signed_in?
      @sites = current_user.sites
      if @sites.count == 0 and !(controller_name == 'sites' and ['new', 'create'].include?(action_name)) and !devise_controller?
        redirect_to new_site_path, notice: t("ac.mandatory") and return
      end
      @on_site_page = (@site.present? and @site.id.present?)
      if @on_site_page
        @permission = current_user.owner_role(@site.id) || current_user.permission_object(@site.id)
        if @permission.blank?
          redirect_to root_url, notice: "Permission denied." and return
        else
          @permission_role = @permission.permission_role
          #@folders = @permission_role.can_see_all_folders ? @site.folders.active : current_user.folders(@site).active
          @role = @permission.ref_role_slug
          @all_workspaces = @permission_role.can_see_all_folders ? @site.folders.active : current_user.folders(@site).active
          @all_workspaces_count = @all_workspaces.count
          @all_verticals = @site.ref_categories.where(genre: "series").order(:name)
          @all_vertical_count = @all_verticals.count
        end
      end
    end
  end

  protected

  def log_additional_data
    if current_user.present?
      request.env["exception_notifier.exception_data"] = {
        current_user: current_user
      }
    end
  end

  def log_user_session
    if current_user.present?
      UserSession.log(session.id, current_user.id, request.remote_ip.to_s, request.env["HTTP_USER_AGENT"].to_s)
    end
  end

end
