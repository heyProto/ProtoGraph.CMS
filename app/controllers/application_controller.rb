class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, unless: :json_request?
  protect_from_forgery with: :null_session, if: :json_request?
  before_action :sudo

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

  private

  def sudo
    if params[:account_id].present?
      @account = Account.friendly.find(params[:account_id])
    elsif controller_name == "accounts" and params[:id].present?
      @account = Account.friendly.find(params[:id])
    end
  	if user_signed_in?
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