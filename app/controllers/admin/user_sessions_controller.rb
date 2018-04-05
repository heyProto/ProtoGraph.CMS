class Admin::UserSessionsController < ApplicationController
    before_action :authenticate_user!
    before_action :sudo_pykih_admin

    def index
        @user_sessions = UserSession.all.order(:user_id, :updated_at).page(params[:page])
    end
end