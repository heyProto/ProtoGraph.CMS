class WelcomeUserMailer < ApplicationMailer

    def welcome(user)
  	    @user = user
  	    mail(to: "team@pykih.com", subject: "#{@user.email} just signed up at protograph", tag: "user-welcome-email")
    end
end
