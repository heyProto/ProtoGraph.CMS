class UserEmailConfirmationMailer < ApplicationMailer
    def send_confirmation(user_email_id)
        @user_email = UserEmail.find(user_email_id)
        mail(to: "#{@user_email.email}", subject: "Confirmation Instructions", tag: "email-confirmation-email")
    end
end
