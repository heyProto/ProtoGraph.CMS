class FoldersController < ApplicationController
  before_action :authenticate_user!
  before_action :sudo_role_can_folder_settings, only: [:edit, :update]

  def new
    @is_admin = true
    @folder = @account.folders.new
    @is_admin = true
    @folder.is_for_stories = true
    @verticals = @site.ref_categories.where(genre: 'series').pluck(:name, :id)
  end

  def edit
    @is_admin = true
    if @folder.is_trash
      redirect_back(fallback_location: [@account], alert: t("pd.folder"))
    end
    @folder.collaborator_lists = @folder.users.pluck(:id)
    @verticals = @site.ref_categories.where(genre: 'series').pluck(:name, :id)
  end

  def update
    folder_params[:updated_by] = current_user.id
    if @folder.update(folder_params)
      track_activity(@folder)
      redirect_to account_site_folder_view_casts_path(@account, @site, @folder), notice: t("us")
    else
      @verticals = @site.ref_categories.where(genre: 'series').pluck(:name, :id)
      @folder.collaborator_lists = @folder.users.pluck(:id)
      @is_admin = true
      render "edit"
    end
  end

  def create
    @folder = @account.folders.new(folder_params)
    @folder.created_by = current_user.id
    @folder.updated_by = current_user.id
    @folder.collaborator_lists = ["#{current_user.id}"] if ["contributor", "writer"].include?(@permission_role.slug)
    if @folder.save
      track_activity(@folder)
      redirect_to account_site_folder_view_casts_path(@account, @site, @folder), notice: t("cs")
    else
      @is_admin = true
      @verticals = @site.ref_categories.where(genre: 'series').pluck(:name, :id)
      render "new"
    end
  end

  private

    def folder_params
      params.require(:folder).permit(:account_id, :name, :created_by, :updated_by, :site_id, :is_archived, :is_open,
                                    :ref_category_vertical_id, :is_for_stories, collaborator_lists: [])
    end

end
