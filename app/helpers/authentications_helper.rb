module AuthenticationsHelper
  def sign_in_user(authentication)
    sign_in_and_redirect(authentication.user)
  end

  def add_new_oauth(authentication, auth)
    token = auth['credentials'].token
    token_secret = auth['credentials'].secret
    current_user.authentications.create!(
      provider: auth['provider'], uid: auth['uid'], 
      access_token: token, access_token_secret: token_secret,
      email: auth["info"]["email"]
    )
    sign_in_and_redirect current_user
  end

  def create_new_user(auth)
    user = User.new
    user.skip_confirmation!
    user.email = auth['info']['email'] if auth['info']['email']
    user.name = auth["info"]["name"]
    if Account.find_by(username: auth.info.nickname).nil?
      username = auth.info.nickname
    elsif Account.where(username: [auth.info.name, auth.info.name.gsub(/\s+/, "_")]).empty?
      username = auth.info.name.gsub(/\s+/, "_")
    else
      username = auth.info.nickname + SecureRandom.hex(1)
    end

    user.username = username
    user.apply_omniauth(auth)
    if user.save 
      sign_in_and_redirect user
    else
      redirect_to new_user_registration_path
    end
  end

  def after_sign_in_path_for(user)
    root_path
  end
end
