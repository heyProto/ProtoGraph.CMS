class StaticPagesController < ApplicationController

  def index
    if current_user
  		redirect_to account_path(current_user.accounts.first)
    else
      redirect_to new_user_session_path
  	end

  end

  def index2
    render layout: false
  end

  def features
  end

  def totimeline
  end

  def toquiz
  end

  def toexplain
  end

  def preparearticle
  end

  def tocounted
  end

  def tocoverage
  end

  def mobbed
  end

  def silenced
  end

end