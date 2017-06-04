class StaticPagesController < ApplicationController

  def index
    if current_user
  		redirect_to edit_account_path(current_user.accounts.first)
  	else
  		redirect_to new_user_session_path
  	end
  end

end