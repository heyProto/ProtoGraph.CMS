class AccountsController < ApplicationController

  before_action :authenticate_user!
  before_action :sudo_role_can_account_settings, only: [:update]

  def new
    @account = Account.new
  end

  def update
    a_params = account_params
    respond_to do |format|
      if @account.update(a_params)
        format.json { respond_with_bip(@account) }
      else
        format.json { respond_with_bip(@account) }
      end
    end
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      current_user.create_permission( "Account", @account.id, "owner")
      folder = Folder.create({
        account_id: @account.id,
        name: "Test drive here",
        created_by: current_user.id,
        updated_by: current_user.id,
        site_id: @account.site.id,
        is_for_stories: false
      })
      folder = Folder.create({
        account_id: @account.id,
        name: "Trash",
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
        @user = current_user
        @accounts_owned = Account.where(id: current_user.permissions.where(ref_role_slug: "owner", permissible_type: "Account").pluck(:permissible_id).uniq)
        @accounts_member = Account.where(id: Site.where(id: current_user.permissions.where(permissible_type: "Site").where.not(ref_role_slug: "owner").pluck(:permissible_id).uniq).pluck(:account_id).uniq)
        render "users/edit"
      end
    end
  end

  private

    def account_params
      params.require(:account).permit(:username, :slug, :status, :host, :cdn_id, :cdn_provider, :cdn_endpoint, :client_token, :access_token, :client_secret, :coming_from_new, :domain, :site_name)
    end

end
