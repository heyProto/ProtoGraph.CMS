class AuthenticationsController < ApplicationController

  before_action :authenticate_user!, :sudo_role_can_site_settings, only: :index

  def create
    omniauth_params = request.env['omniauth.params']
    current_user_id = omniauth_params['current_user_id'].to_i
    authentication = Authentication.from_omniauth(request.env["omniauth.auth"], account_id, current_user_id) #DEEP AND AMIT TO REMOVE ACCOUNT_ID
    redirect_to site_owners_site_admins_path(id: account_id), notice: "Successfully authenticated." #DEEP AND AMIT TO REMOVE ACCOUNT_ID
  end

  def failure
    omniauth_params = request.env['omniauth.params']
    account_id = omniauth_params['account_id'].to_i  #DEEP AND AMIT TO REMOVE ACCOUNT_ID
    redirect_to site_owners_site_admins_path(id: account_id), alert: "Authentication Error: #{params['error_description']}"  #DEEP AND AMIT TO REMOVE ACCOUNT_ID
  end

  def destroy
    @authentication = Authentication.find(params[:id])
    @authentication.destroy
    redirect_to site_owners_site_admins_path(@site), notice: "Successfully deleted."
  end

end
