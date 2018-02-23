class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, unless: :json_request?
  protect_from_forgery with: :null_session, if: :json_request?
  before_action :sudo
  after_action :user_activity

  def json_request?
    request.format.json?
  end

  def sudo_pykih_admin
    redirect_to root_url, notice: "Permission denied." unless current_user.is_admin_from_pykih and return
  end

  def sudo_role_can_account_settings
    redirect_to account_site_path(@account, @site), notice: "Permission denied" unless @permission_role.can_change_account_settings and return
  end

  def sudo_role_can_site_settings
    redirect_to account_site_path(@account, @site), notice: "Permission denied" unless @permission_role.can_change_site_settings and return
  end

  def sudo_role_can_add_site_people
    redirect_to account_site_path(@account, @site), notice: "Permission denied" unless @permission_role.can_add_site_people and return
  end

  def sudo_role_can_add_site_categories
    redirect_to account_site_path(@account, @site), notice: "Permission denied" unless @permission_role.can_add_site_categories and return
  end

  def sudo_role_can_disable_site_categories
    redirect_to account_site_path(@account, @site), notice: "Permission denied" unless @permission_role.can_disable_site_categories and return
  end

  def sudo_role_can_folder_settings
    redirect_to account_site_path(@account, @site), notice: "Permission denied" unless @permission_role.can_add_folder_people and return
  end

  def sudo_role_can_add_site_tags
    redirect_to account_site_path(@account, @site), notice: "Permission denied" unless @permission_role.can_add_site_tags and return
  end

  def sudo_can_see_all_folders
    if !@permission_role.can_see_all_folders and @folder.users.pluck(:user_id).uniq.exclude?(current_user.id)
      redirect_to account_site_path(@account, @site), notice: "Permission denied" and return
    end
  end

  def sudo_can_see_all_view_casts
    if !@permission_role.can_see_all_view_casts and @view_cast.users.pluck(:user_id).uniq.exclude?(current_user.id)
      redirect_to account_site_path(@account, @site), notice: "Permission denied" and return
    end
  end

  def sudo_can_see_all_pages
    if !@permission_role.can_see_all_pages and @page.users.pluck(:user_id).uniq.exclude?(current_user.id)
      redirect_to account_site_path(@account, @site), notice: "Permission denied" and return
    end
  end

  def sudo_can_see_all_streams
    if !@permission_role.can_see_all_streams and @stream.users.pluck(:user_id).uniq.include?(current_user.id)
      redirect_to account_site_path(@account, @site), notice: "Permission denied" and return
    end
  end

  def sudo_role_can_template_designer
    redirect_to root_url, notice: "Permission denied" and return
  end

  def track_activity(trackable, action = params[:action])
    if @account.present?
      if @folder.present?
          current_user.activities.create!(action: action, trackable: trackable, account_id: @account.id, folder_id: @folder.id, site_id: @site.id)
      else
          current_user.activities.create!(action: action, trackable: trackable, account_id: @account.id, site_id: @site.id)
      end
    end
  end

  def user_activity
    current_user.try :touch
  end

  private

  def sudo
    if params[:account_id].present?
      @account = Account.friendly.find(params[:account_id])
      @site = @account.site
      if params[:folder_id].present?
        @folder = @account.folders.friendly.find(params[:folder_id])
      elsif controller_name == "folders" and params[:id].present?
        @folder = @account.folders.friendly.find(params[:id])
      end
    elsif controller_name == "accounts" and params[:id].present?
      @account = Account.friendly.find(params[:id])
      @site = @account.site
    end

  	if user_signed_in?
      @accounts = current_user.accounts
      if @accounts.count == 0 and !(controller_name == 'accounts' and ['new', 'create'].include?(action_name)) and !devise_controller?
        redirect_to new_account_path, notice: t("ac.mandatory") and return
      end
  		@on_an_account_page = (@account.present? and @account.id.present?)
      if @on_an_account_page
        @permission = current_user.owner_role(@account.id) || current_user.permission_object(@site.id)
        if @permission.blank?
          redirect_to root_url, notice: "Permission denied." and return
        else
          @permission_role = @permission.permission_role
          @folders = @permission_role.can_see_all_folders ? @site.folders.active : current_user.folders(@site).active
          @role = @permission.ref_role_slug
        end
      end
  	end
  end

end
