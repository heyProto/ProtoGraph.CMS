class AccountsController < ApplicationController

  before_action :authenticate_user!
  before_action :sudo_role_can_account_settings, only: [:edit, :update]

  def index
    @accounts = current_user.accounts
    @account = Account.new
  end

  def edit
    @people_count = @account.users.count
    @pending_invites_count = @account.permission_invites.count
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
      @account.create_permission(current_user.id, "owner")
      redirect_to @account, notice: t("cs")
    else
      @accounts = current_user.accounts
      render :index
    end
  end

  private

    def account_params
      params.require(:account).permit(:username, :slug, :domain, :gravatar_email)
    end

end
