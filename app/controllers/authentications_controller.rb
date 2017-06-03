class AuthenticationsController < ApplicationController

  def index
    @authentications = @account.authentications
    @fb_auth = @authentications.fb_auth
    @tw_auth = @authentications.tw_auth
    @insta_auth = @authentications.insta_auth
  end

  def create
    omniauth_params = request.env['omniauth.params']
    account_id = omniauth_params['account_id'].to_i
    current_user_id = omniauth_params['current_user_id'].to_i
    authentication = Authentication.from_omniauth(request.env["omniauth.auth"], account_id, current_user_id)
    redirect_to account_authentication_path(account_id: account_id), notice: "Authentication via #{request.env["omniauth.auth"]["provider"].titleize} successful."
  end

  def failure
    omniauth_params = request.env['omniauth.params']
    account_id = omniauth_params['account_id'].to_i
    redirect_to account_authentication_path(account_id: account_id), alert: "Authentication Error: #{params['error_description']}"
  end

end