class AccountsController < ApplicationController

  before_action :authenticate_user!
  before_action :sudo_role_can_account_settings, only: [:edit, :update]

  #Your Accounts - Switch Accounts
  def index
    @accounts = current_user.accounts
    @account = Account.new
  end

  def show
    @folders = @account.folders
    @folder = Folder.new
  end

  def edit
    @people_count = @account.users.count
    @pending_invites_count = @account.permission_invites.count
    @fb_auth = @account.authentications.fb_auth.first
    @tw_auth = @account.authentications.tw_auth.first
    @insta_auth = @account.authentications.insta_auth.first
  end

  def update
    if @account.update(account_params)
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
      current_user.create_permission(@account.id, "owner")
      folder = Folder.create({
        account_id: @account.id,
        name: "Sample Project",
        created_by: current_user.id,
        updated_by: current_user.id
      })
      redirect_to @account, notice: t("cs")
    else
      @accounts = current_user.accounts
      render :index
    end
  end

  def template_cards
  end

  private

    def account_params
      params.require(:account).permit(:username, :slug, :domain, :gravatar_email, :status, :sign_up_mode, :host, :cdn_id, :cdn_provider, :cdn_endpoint, :client_token, :access_token, :client_secret)
    end

end
