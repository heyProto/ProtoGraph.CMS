class AccountsController < ApplicationController

  before_action :authenticate_user!

  def show
    @view_casts = @account.view_casts.order(updated_at: :desc).page(params[:page]).per(30)
    render "view_casts/index"
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
    @folder = @account.folders.new(folder_params)
    if @folder.save
      redirect_to account_folder_path(@account, @folder), notice: t("cs")
    else
      render "accounts/show"
    end
  end

  private

    def folder_params
      params.require(:folder).permit(:account_id, :name)
    end

end
