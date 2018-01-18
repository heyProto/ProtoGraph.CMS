class SitesController < ApplicationController
  
  before_action :authenticate_user!
  before_action :sudo_role_can_account_settings, only: [:edit, :update]
  
  def edit
  end
  
  def update
  end
  
  private
  
  def site_params
    params.require(:site).permit(:account_id, :name, :domain, :description, :primary_language, :default_seo_keywords, :house_colour, :reverse_house_colour, :font_colour, :reverse_font_colour, :stream_url, :stream_id)
  end
  
end


