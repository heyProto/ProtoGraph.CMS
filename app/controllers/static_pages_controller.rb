class StaticPagesController < ApplicationController

  def index
    if current_user
  		redirect_to account_path(current_user.accounts.first)
  	else
  		redirect_to new_user_session_path
  	end
  end

  def features
  end

end