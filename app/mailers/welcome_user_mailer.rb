class WelcomeUserMailer < ApplicationMailer

    def welcome(user)
  	    @user = user
  	    mail(to: "team@pykih.com, solstad@icfj.org", subject: "ProtoGraph Sign up by #{@user.email} <EOM>.", tag: "user-welcome-email")
    end
end
