class AccountsController < ApplicationController

  before_action :authenticate_user!
  before_action :sudo_role_can_account_settings, only: [:edit, :update]

  def new
    @account = Account.new
  end

  def edit
    @permissions = @account.permissions.not_hidden.where(ref_role_slug: "owner").includes(:user).page params[:page]
    @permission_invite = PermissionInvite.new
    @permission_invites = @account.permission_invites.where(ref_role_slug: "owner")
    @people_count = @account.permissions.not_hidden.where(ref_role_slug: "owner").count
    @pending_invites_count = @account.permission_invites.where(ref_role_slug: "owner").count
    @permission_invites = @account.permission_invites.where(ref_role_slug: "owner")

    @people_count = @account.permissions.not_hidden.where(ref_role_slug: "owner").count
    @pending_invites_count = @account.permission_invites.where(ref_role_slug: "owner").count
  end

  def update
    a_params = account_params
    respond_to do |format|
      if @account.update(a_params)
        format.json { respond_with_bip(@account) }
        format.html {
          redirect_to edit_account_path(@account), notice: t("us")
        }
      else
        format.json { respond_with_bip(@account) }
        format.html {
          @permissions = @account.permissions.not_hidden.where(ref_role_slug: "owner").includes(:user).page params[:page]
          @people_count = @account.users.count
          @permission_invite = PermissionInvite.new
          @permission_invites = @account.permission_invites.where(ref_role_slug: "owner")
          @people_count = @account.permissions.not_hidden.where(ref_role_slug: "owner").count
          @pending_invites_count = @account.permission_invites.where(ref_role_slug: "owner").count
          @permission_invites = @account.permission_invites.where(ref_role_slug: "owner")

          @people_count = @account.permissions.not_hidden.where(ref_role_slug: "owner").count
          @pending_invites_count = @account.permission_invites.where(ref_role_slug: "owner").count
          render "edit"
        }
      end
    end
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      current_user.create_permission( "Account", @account.id, "owner")
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
      redirect_to account_site_path(@account, @account.site), notice: t("cs")
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
      params.require(:account).permit(:username, :slug, :status, :host, :cdn_id, :cdn_provider, :cdn_endpoint, :client_token, :access_token, :client_secret, :coming_from_new, :domain)
    end

end
