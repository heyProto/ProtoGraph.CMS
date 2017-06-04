class AccountsController < ApplicationController

  before_action :authenticate_user!

  def index
    @accounts = current_user.accounts
    @account = Account.new
  end

  def edit
  end

  def update
    if @account.update(account_params)
      redirect_to edit_account_path(@account), notice: t("us")
    else
      render :edit
    end
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      @account.create_permission(current_user.id)
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
