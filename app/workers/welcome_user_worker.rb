class WelcomeUserWorker
    include Sidekiq::Worker
    sidekiq_options :backtrace => true

    def perform(user_id)
        @user = User.find(user_id)
        WelcomeUserMailer.welcome(@user).deliver_later
    end
end
