class AccountsController < ApplicationController

  before_action :authenticate_user!
  before_action :sudo_role_can_account_settings, only: [:edit, :update]

  #Your Accounts - Switch Accounts
  def index
    @accounts = current_user.accounts
    @account = Account.new
  end

  def show
    @view_casts = @account.view_casts.order(updated_at: :desc).page(params[:page]).per(30)
    render "view_casts/index"
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
      params.require(:account).permit(:username, :slug, :domain, :gravatar_email, :status)
    end

end
