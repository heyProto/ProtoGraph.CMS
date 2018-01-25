class StaticPagesController < ApplicationController

  def index
    if current_user
      if current_user.accounts.count  == 0
        redirect_to new_account_path
      else current_user.accounts.count > 1
        redirect_to account_site_path(current_user.accounts.first, current_user.accounts.first.site)
      end
    else
      redirect_to new_user_session_path
  	end

  end

  def index2
    render layout: false
  end

  def features
  end

  def toexplain
    render layout: "three_column_grid"
  end

  def preparearticle
    render layout: "three_column_grid"
  end

  def tocounted
    render layout: "three_column_grid"
  end

  def tocoverage
    render layout: "three_column_grid"
  end

  def mobbed
  end

  def silenced
  end

  def toquiz
    render layout: "application-sites"
  end

  def totimeline
    render layout: "application-sites"
  end

end