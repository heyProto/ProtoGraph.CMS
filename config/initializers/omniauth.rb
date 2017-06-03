Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  provider :instagram, ENV['INSTAGRAM_ID'], ENV['INSTAGRAM_SECRET']
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']

  OmniAuth.config.on_failure = Proc.new do |env|
    #this will invoke the omniauth_failure action in SessionsController.
    "AuthenticationsController".constantize.action(:failure).call(env)
  end
end