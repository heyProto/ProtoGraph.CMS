class SitesController < ApplicationController

  before_action :authenticate_user!
  before_action :sudo_role_can_add_site, only: [:new, :create]
  before_action :sudo_role_can_site_settings, only: [:edit, :update]

  def remove_favicon
    @site.update_attributes(favicon_id: nil)
    redirect_to edit_account_site_path(@account, @site)
  end

  def show
    folder = @permission_role.can_see_all_folders ? @site.folders.active.where(is_trash: false).first : current_user.folders(@site).active.where(is_trash: false).first
    redirect_to account_site_folder_view_casts_path(@account, @site, folder)
  end

  def remove_logo
    @site.update_attributes(logo_image_id: nil)
    redirect_to edit_account_site_path(@account, @site)
  end

  def edit
    if @site.favicon_id.nil? or @site.favicon.nil?
      @site.build_favicon
    end
    if @site.logo_image_id.nil?
      @site.build_logo_image
    end
    @is_admin = true
    render layout: "z"
  end

  def integrations
    @is_admin = true
    render layout: "z"
  end

  def update
    from = params[:site][:from_page]
    site_p = site_params
    unless site_p.has_key?("logo_image_attributes") and site_p["logo_image_attributes"].has_key?("image")
      site_p.delete('logo_image_attributes')
    end
    unless site_p.has_key?("favicon_attributes") and site_p["favicon_attributes"].has_key?("image")
      site_p.delete('favicon_attributes')
    end
    if @site.update(site_p)
      if from == "product_integrations"
        redirect_to integrations_account_site_path(@account, @site), notice: 'site was successfully updated.'
      elsif from == "access_security"
        redirect_to access_security_account_site_admins_path(@account, @site), notice: 'site was successfully updated.'
      else
        redirect_to edit_account_site_path(@account, @site), notice: 'site was successfully updated.'
      end
    else
      @permission_role = PermissionRole.where.not(slug: 'owner').pluck(:name, :slug)
      if from == "product_integrations"
        render :integrations, layout: "z"
      elsif from == "access_security"
        render "admins/access_security", layout: "z"
      else
        render :edit, layout: "z"
      end
    end
  end

  private

  def site_params
    params.require(:site).permit(:show_proto_logo, :from_page, :account_id, :name, :domain, :sign_up_mode,:description, :primary_language, :tooltip_on_logo_in_masthead, :default_seo_keywords, :is_lazy_loading_activated, :is_smart_crop_enabled,:house_colour, :reverse_house_colour, :font_colour, :reverse_font_colour, :stream_url, :email_domain, :stream_id, :cdn_provider, :cdn_id, :host, :cdn_endpoint, :client_token, :access_token, :story_card_style, :client_secret, :facebook_url, :twitter_url, :instagram_url, :youtube_url, :g_a_tracking_id, :logo_image_id, :favicon_id, :default_role, :sign_up_mode, :header_background_color, :header_url, :header_positioning, :english_name, :is_english, :story_card_flip, :seo_name, :comscore_code, :gtm_id, :enable_ads, logo_image_attributes: [:image, :account_id, :is_logo, :created_by, :updated_by], favicon_attributes: [:image, :account_id, :is_favicon, :created_by, :updated_by])
  end

end


