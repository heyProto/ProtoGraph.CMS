class FoldersController < ApplicationController

  before_action :authenticate_user!

  def show
    @view_casts = @folder.view_casts.order(updated_at: :desc).page(params[:page]).per(9)
    @streams = @folder.streams.order(updated_at: :desc)
    @articles = @folder.articles.order(updated_at: :desc)
  end

  def edit
    @folders = @account.folders
    @open_modal = true
    render "accounts/show"
  end

  def update
    folder_params[:updated_by] = current_user.id
    if @folder.update(folder_params)
      redirect_to account_path(@account), notice: t("us")
    else
      @folders = @account.folders
      @open_modal = true
      render "accounts/show"
    end
  end

  def create
    @folder = @account.folders.new(folder_params)
    @folder.created_by = current_user.id
    @folder.updated_by = current_user.id
    if @folder.save
      redirect_to account_folder_path(@account, @folder), notice: t("cs")
    else
      @folders = @account.folders
      @open_modal = true
      render "accounts/show"
    end
  end

  private

    def folder_params
      params.require(:folder).permit(:account_id, :name, :created_by, :updated_by)
    end

end
