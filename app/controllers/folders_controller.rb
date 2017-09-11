class FoldersController < ApplicationController
  before_action :authenticate_user!

  def show
    @view_casts_count = @folder.view_casts.count
    @streams_count = @folder.streams.count
    @articles_count = @folder.articles.count
    @view_casts = @folder.view_casts.order(updated_at: :desc).page(params[:page]).per(30)
    @is_viewcasts_present = @view_casts.count != 0
    render layout: "application-fluid"
  end

  def new
    @folder = @account.folders.new()
  end

  def edit
  end

  def update
    folder_params[:updated_by] = current_user.id
    if @folder.update(folder_params)
      track_activity(@folder)
      redirect_to account_path(@account), notice: t("us")
    else
      render "edit"
    end
  end

  def create
    @folder = @account.folders.new(folder_params)
    @folder.created_by = current_user.id
    @folder.updated_by = current_user.id
    if @folder.save
      track_activity(@folder)
      redirect_to account_folder_path(@account, @folder), notice: t("cs")
    else
      render "new"
    end
  end

  private

    def folder_params
      params.require(:folder).permit(:account_id, :name, :created_by, :updated_by)
    end

end
