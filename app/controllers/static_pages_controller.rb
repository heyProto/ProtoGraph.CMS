class StaticPagesController < ApplicationController

  def index
    if current_user
      n_sites = current_user.sites.count
      if n_sites  == 0
        redirect_to new_site_path
      else n_sites > 1
        redirect_to site_path(current_user.sites.first)
      end
    else
      redirect_to new_user_session_path
  	end
  end

end