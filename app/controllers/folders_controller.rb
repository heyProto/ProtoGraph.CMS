class FoldersController < ApplicationController
  before_action :authenticate_user!
  before_action :sudo_can_see_all_folders, only: [:show]
  before_action :sudo_role_can_folder_settings, only: [:edit, :update]

  def show
      @view_casts_count = @folder.view_casts.where.not(template_card_id: TemplateCard.to_story_cards_ids).count
      @view_casts = @permission_role.can_see_all_view_casts ? @folder.view_casts.where.not(template_card_id: TemplateCard.to_story_cards_ids).order(updated_at: :desc).page(params[:page]).per(30) : current_user.view_casts(@folder).order(updated_at: :desc).page(params[:page]).per(30)
      @is_viewcasts_present = @view_casts.count != 0
      @activities = [] # @account.activities.where(folder_id: @folder.id).order("updated_at DESC").limit(30) Need to update the logic for permission
      @page_count = @folder.pages.count
      @page = Page.new
      render layout: "application-fluid"
  end

  def new
    @folder = @account.folders.new
    @verticals = @site.ref_categories.where(genre: 'series').pluck(:name, :id)
  end

  def edit
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
      redirect_to account_site_folder_path(@account, @site, @folder), notice: t("us")
    else
      @verticals = @site.ref_categories.where(genre: 'series').pluck(:name, :id)
      @folder.collaborator_lists = @folder.users.pluck(:id)
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
      redirect_to account_site_folder_path(@account, @site, @folder), notice: t("cs")
    else
      @verticals = @site.ref_categories.where(genre: 'series').pluck(:name, :id)
      render "new"
    end
  end

  private

    def folder_params
      params.require(:folder).permit(:account_id, :name, :created_by, :updated_by, :site_id, :is_open, :ref_category_vertical_id, collaborator_lists: [])
    end

end
