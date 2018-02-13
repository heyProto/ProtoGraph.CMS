class User::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include AuthenticationsHelper
  def twitter

    auth = request.env['omniauth.auth']
    authentication = Authentication.find_by(provider: auth['provider'], uid:  auth['uid'].to_s)
    user = User.find_by(email: auth.info.email)

    ## If a user is signed in and wants to add twitter authentication
    if current_user.present?

      if authentication.present?
        if authentication.user != current_user
          redirect_to edit_user_registration_path, alert: "Twitter user is associated with another account" and return
        else
          redirect_to edit_user_registration_path, alert: "Your account is already linked with twitter" and return
        end
      else
        add_new_oauth(authentication, auth)
      end

    ## When a user is persisted but isnt logged in
    ## and wants to sign in using twitter
    elsif authentication

      sign_in_user(authentication)

    ## If user is persisted but not authenticated with twitter
    elsif user.present?

      user.apply_omniauth(auth)
      sign_in_user(user.authentications.first)

    ## When the user isnt persisted and isnt authenticated with twitter
    else
      redirect_to root_url, alert: "No existing account found associated with this email ID."
      #create_new_user(auth)

    end

  end

  def failure
    redirect_to root_url, alert: "Something went wrong"
  end
end
