class Admin::OnlineUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :sudo_pykih_admin

  def index
    @online_users = User.online
  end
end
