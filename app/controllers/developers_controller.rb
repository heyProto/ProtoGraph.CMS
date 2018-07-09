class DevelopersController < ApplicationController
  
  before_action :authenticate_user!
  before_action :sudo_role_can_site_settings
  
  def index
  end
  
end
