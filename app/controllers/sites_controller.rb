class SitesController < ApplicationController

  before_action :authenticate_user!
  before_action :sudo_role_can_add_site, only: [:new, :create]
  before_action :sudo_role_can_site_settings, only: [:edit, :update]

  def show
    @folders = @permission_role.can_see_all_folders ? @site.folders : current_user.folders(@site)
    @folder = Folder.new
    @activities = [] #@account.activities.order("updated_at DESC").limit(30) Need to update the logic for permission
  end


  def edit
    if @site.logo_image_id.nil?
      @site.build_logo_image
    end
    if @site.favicon_id.nil?
      @site.build_favicon
    end
  end

  def update
    if @site.update(site_params)
      redirect_to edit_account_site_path(@account, @site), notice: 'site was successfully updated.'
    else
      render :edit
    end
  end

  private

  def site_params
    params.require(:site).permit(:account_id, :name, :domain, :sign_up_mode,:description, :primary_language, :default_seo_keywords,
                                 :house_colour, :reverse_house_colour, :font_colour, :reverse_font_colour, :stream_url, :email_domain,
                                 :stream_id, :cdn_provider, :cdn_id, :host, :cdn_endpoint, :client_token, :access_token, :story_card_style,
                                 :client_secret, :facebook_url, :twitter_url, :instagram_url, :youtube_url, :g_a_tracking_id, :logo_image_id, :favicon_id, :default_role, :sign_up_mode,
                                 logo_image_attributes: [:image, :account_id, :is_logo, :created_by, :updated_by],
                                 favicon_attributes: [:image, :account_id, :is_favicon, :created_by, :updated_by])
  end

end


