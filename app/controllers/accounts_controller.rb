class AccountsController < ApplicationController

  before_action :authenticate_user!
  before_action :sudo_role_can_account_settings, only: [:edit, :update]

  #Your Accounts - Switch Accounts
  def index
    @account = Account.new
  end

  def show
    @folders = @account.folders
    @folder = Folder.new
    @activities = @account.activities.order("updated_at DESC").limit(30)
  end

  def edit
    @people_count = @account.users.count
    @pending_invites_count = @account.permission_invites.count
    @fb_auth = @account.authentications.fb_auth.first
    @tw_auth = @account.authentications.tw_auth.first
    @insta_auth = @account.authentications.insta_auth.first
    if @account.logo_image_id.nil?
      @account.build_logo_image
    end
  end

  def update
    a_params = account_params
    if a_params["logo_image_attributes"].present?
      a_params["logo_image_attributes"]["name"] = @account.username + "_avatar"
      a_params["logo_image_attributes"]["tag_list"] = ['avatar']
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
      render :edit
    end
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      RefCode.seed(@account.id, current_user.id)
      current_user.create_permission(@account.id, "owner")
      folder = Folder.create({
        account_id: @account.id,
        name: "Sample Project",
        created_by: current_user.id,
        updated_by: current_user.id
      })
      folder = Folder.create({
        account_id: @account.id,
        name: "Recycle Bin",
        created_by: current_user.id,
        updated_by: current_user.id,
        is_trash: true,
        is_system_generated: true
      })
      redirect_to @account, notice: t("cs")
    else
      render :index
    end
  end

  def template_cards
  end

  private

    def account_params
      params.require(:account).permit(:username, :slug, :domain, :status, :sign_up_mode, :host, :cdn_id, :cdn_provider, :cdn_endpoint, :client_token, :access_token, :client_secret, :logo_image_id, :house_colour, logo_image_attributes: [:image])
    end

end
