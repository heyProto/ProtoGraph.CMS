class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, unless: :json_request?
  protect_from_forgery with: :null_session, if: :json_request?
  before_action :sudo
  after_action :user_activity

  def json_request?
    request.format.json?
  end

  def sudo_pykih_admin
    redirect_to root_url, notice: "Permission denied." if !current_user.is_admin_from_pykih
  end

  def sudo_role_can_account_settings
    redirect_to root_url, notice: "Permission denied" if !@role.can_account_settings
  end

  def sudo_role_can_template_designer
    redirect_to root_url, notice: "Permission denied" if (!@role.can_template_design_do and !@role.can_template_design_publish)
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
      if params[:folder_id].present?
        @folder = @account.folders.friendly.find(params[:folder_id])
      elsif controller_name == "folders" and params[:id].present?
        @folder = @account.folders.friendly.find(params[:id])
      end
      @site = @account.site
    elsif controller_name == "accounts" and params[:id].present?
      @account = Account.friendly.find(params[:id])
      @site = @account.site
    end
  	if user_signed_in?
      @accounts = current_user.accounts
      if @accounts.count == 0 and !(controller_name = 'accounts' and ['new', 'create'].include?(action_name)) and !devise_controller?
        redirect_to new_account_path, notice: t("ac.mandatory") and return
      end
  		@on_an_account_page = (@account.present? and @account.id.present?)
      if @on_an_account_page
        @permission = current_user.permission_object(@account.id)
        if @permission.blank?
          redirect_to root_url, notice: "Permission denied."
        else
          @role = @permission.ref_role
        end
      end
  	end
  end

end
