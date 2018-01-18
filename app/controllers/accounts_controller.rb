class AccountsController < ApplicationController

  before_action :authenticate_user!
  before_action :sudo_role_can_account_settings, only: [:update]
  
  def edit
    @permissions = @account.permissions.not_hidden.where(ref_role_slug: "owner").includes(:user).page params[:page]
    @permission_invite = PermissionInvite.new
    @permission_invites = @account.permission_invites.where(ref_role_slug: "owner")
    @people_count = @account.permissions.not_hidden.where(ref_role_slug: "owner").count
    @pending_invites_count = @account.permission_invites.where(ref_role_slug: "owner").count
    @permission_invites = @account.permission_invites.where(ref_role_slug: "owner")
    
    @people_count = @account.permissions.not_hidden.where(ref_role_slug: "owner").count
    @pending_invites_count = @account.permission_invites.where(ref_role_slug: "owner").count
    
    






    
    
    if @account.logo_image_id.nil?
      @account.build_logo_image
    end
  end

  def show
    @folders = @account.folders
    @folder = Folder.new
    @activities = @account.activities.order("updated_at DESC").limit(30)
  end

  def update
    a_params = account_params
    if params["commit"] == "Save" and a_params["logo_image_id"].blank?
      a_params.delete("logo_image_id")
    end
    if a_params["logo_image_attributes"].present?
      a_params["logo_image_attributes"]["name"] = @account.username + "_avatar"
      a_params["logo_image_attributes"]["account_id"] = @account.id
      a_params["logo_image_attributes"]["created_by"] = current_user.id
      a_params["logo_image_attributes"]["updated_by"] = current_user.id
      a_params["logo_image_attributes"]["is_logo"] = true
    end

    if @account.update(a_params)
      redirect_to edit_account_path(@account), notice: t("us")
    else
      @people_count = @account.users.count
      @pending_invites_count = @account.permission_invites.count
      render edit_account_path(@account)
    end
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      current_user.create_permission(@account.id, "owner")
      folder = Folder.create({
        account_id: @account.id,
        name: "Sample Project",
        created_by: current_user.id,
        updated_by: current_user.id,
        site_id: @account.site.id
      })
      folder = Folder.create({
        account_id: @account.id,
        name: "Recycle Bin",
        created_by: current_user.id,
        updated_by: current_user.id,
        is_trash: true,
        is_system_generated: true,
        site_id: @account.site.id
      })
      redirect_to account_path(@account), notice: t("cs")
    else
      if @account.coming_from_new
        render "accounts/new"
      else
        render "users/edit"
      end
    end
  end

  private

    def account_params
      params.require(:account).permit(:username, :slug, :domain, :status, :sign_up_mode, :host, :cdn_id, :cdn_provider, :cdn_endpoint, :client_token, :access_token, :client_secret, :logo_image_id, :house_colour, :reverse_house_colour, :font_colour, :reverse_font_colour, :coming_from_new, logo_image_attributes: [:image])
    end

end
