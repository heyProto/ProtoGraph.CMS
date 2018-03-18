class SitesController < ApplicationController

  before_action :authenticate_user!
  before_action :sudo_role_can_add_site, only: [:new, :create]
  before_action :sudo_role_can_site_settings, only: [:edit, :update]

  def show
    @folder = Folder.new
    @folders = @permission_role.can_see_all_folders ? @site.folders.active : current_user.folders(@site).active
    @activities = [] #@account.activities.order("updated_at DESC").limit(30) Need to update the logic for permission
  end

  def update
    from = params[:site][:from_page]
    if @site.update(site_params)
      if from == "site_setup"
        redirect_to site_setup_account_site_admins_path(@account, @site), notice: 'site was successfully updated.'
      elsif from = "sites"
        redirect_to sites_account_admins_path(@account), notice: 'site was successfully updated.'
      elsif from == "product_theme"
        redirect_to site_theming_account_site_admins_path(@account, @site), notice: 'site was successfully updated.'
      elsif from == "basic_theming"
        redirect_to basic_theming_account_site_admins_path(@account, @site), notice: 'site was successfully updated.'
      elsif from == "product_integrations"
        redirect_to site_integrations_account_site_admins_path(@account, @site), notice: 'site was successfully updated.'
      elsif from == "access_security"
        redirect_to access_security_account_site_admins_path(@account, @site), notice: 'site was successfully updated.'
      end
    else
      @permission_role = PermissionRole.where.not(slug: 'owner').pluck(:name, :slug)
      if from == "site_setup"
        render "admins/site_setup"
      elsif from == "product_theme"
        render "admins/product_theme"
      elsif from == "product_integrations"
        render "admins/product_integrations"
      elsif from == "access_security"
        render "admins/access_security"
      end
    end
  end

  private

  def site_params
    params.require(:site).permit(:from_page, :account_id, :name, :domain, :sign_up_mode,:description, :primary_language, :default_seo_keywords, :is_lazy_loading_activated,
                                 :house_colour, :reverse_house_colour, :font_colour, :reverse_font_colour, :stream_url, :email_domain,
                                 :stream_id, :cdn_provider, :cdn_id, :host, :cdn_endpoint, :client_token, :access_token, :story_card_style,
                                 :client_secret, :facebook_url, :twitter_url, :instagram_url, :youtube_url, :g_a_tracking_id, :logo_image_id, :favicon_id, :default_role, :sign_up_mode,
                                 :header_background_color, :header_url, :header_positioning, :english_name, :is_english, :story_card_flip, :seo_name,
                                 logo_image_attributes: [:image, :account_id, :is_logo, :created_by, :updated_by],
                                 favicon_attributes: [:image, :account_id, :is_favicon, :created_by, :updated_by])
  end

end


