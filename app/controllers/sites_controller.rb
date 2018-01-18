class SitesController < ApplicationController

  before_action :authenticate_user!
  before_action :sudo_role_can_account_settings, only: [:edit, :update]


  def edit
  end

  def update
    respond_to do |format|
      if @site.update(site_params)
        format.html { redirect_to edit_account_site_path(@account, @site), notice: 'site was successfully updated.' }
        format.json { render :show, status: :ok, location: @site }
      else
        format.html { render :edit }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def site_params
    params.require(:site).permit(:account_id, :name, :domain, :description, :primary_language, :default_seo_keywords, :house_colour, :reverse_house_colour, :font_colour, :reverse_font_colour, :stream_url, :stream_id, :cdn_provider, :cdn_id, :host, :cdn_endpoint, :client_token, :access_token, :client_secret, :facebook_url, :twitter_url, :instagram_url, :youtube_url)
  end

end


