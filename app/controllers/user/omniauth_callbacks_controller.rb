class User::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include AuthenticationsHelper
  def twitter
    ## If a user is signed in
    # Adds an authentication for the current user

    auth = request.env['omniauth.auth']
    authentication = Authentication.find_by(provider: auth['provider'], uid:  auth['uid'].to_s)
    user = User.find_by(email: auth.info.email)

    # User is signed in and tries to login
    # with email twitter email other than account email
    if (current_user.email != auth.info.email) and authentication.present?
      redirect_to edit_user_registration_path, alert: "Twitter user is associated with another account" and return
    elsif authentication
      sign_in_user(authentication)
    elsif current_user
      add_new_oauth(authentication, auth)
    elsif user.present?
      user.apply_omniauth(auth)
      sign_in_user(u.authentications.first)
    else
      create_new_user(auth)
    end

  end

  def failure
    redirect_to root_url, alert: "Something went wrong"
  end
end
