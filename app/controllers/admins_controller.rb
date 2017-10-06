class AdminsController < ApplicationController
  before_action :sudo_pykih_admin

  def online_users
    @online_users = User.online
  end
end
