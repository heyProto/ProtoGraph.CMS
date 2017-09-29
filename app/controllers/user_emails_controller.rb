class UserEmailsController < ApplicationController

    before_action :authenticate_user!
    before_action :set_user_email, only: [:destroy]

    def index
        @user_email = UserEmail.new
        @user_emails = current_user.user_emails
    end

    def create
        @user_email = current_user.user_emails.build(user_email_params)
        @user_email.confirmation_sent_at = Time.now
        @user_email.confirmation_token = SecureRandom.hex(10)
        respond_to do |format|
            if @user_email.save
                UserEmailConfirmationMailer.send_confirmation(@user_email.id).deliver_later
                format.html { redirect_to user_emails_path(current_user), notice: I18n.t(".user_email.create.success") }
            else
                format.html { redirect_to user_emails_path(current_user), alert: I18n.t(".user_email.create.failure") }
            end
        end
    end

    def destroy
        @user_email.destroy
        respond_to do |format|
            format.html { redirect_to user_emails_path(current_user), notice: I18n.t(".user_email.destroy.success")}
        end
    end

    def confirmation
        @user_email = current_user.user_emails.find_by(confirmation_token: params[:confirmation_token])
        @user_email.confirmed_at = Time.now
        if @user_email.save
            redirect_to user_emails_path(current_user), notice: I18n.t(".user_email.confirmation.success")
        else
            redirect_to user_emails_path(current_user), alert: I18n.t(".user_email.confirmation.failure")
        end
    end
    private
    def set_user_email
        @user_email = UserEmail.find(params[:id])
    end

    def user_email_params
        params.require(:user_email).permit(:email)
    end
end
