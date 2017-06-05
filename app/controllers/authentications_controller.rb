class AuthenticationsController < ApplicationController

  before_action :authenticate_user!, :sudo_role_can_account_settings, only: :index

  def create
    omniauth_params = request.env['omniauth.params']
    account_id = omniauth_params['account_id'].to_i
    current_user_id = omniauth_params['current_user_id'].to_i
    authentication = Authentication.from_omniauth(request.env["omniauth.auth"], account_id, current_user_id)
    redirect_to edit_account_path(id: account_id), notice: "Successfully authenticated."
  end

  def failure
    omniauth_params = request.env['omniauth.params']
    account_id = omniauth_params['account_id'].to_i
    redirect_to edit_account_path(id: account_id), alert: "Authentication Error: #{params['error_description']}"
  end

  def destroy
    @authentication = Authentication.find(params[:id])
    @authentication.destroy
    redirect_to edit_account_path(@account), notice: "Successfully deleted."
  end

end