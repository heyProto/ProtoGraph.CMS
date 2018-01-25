class FoldersController < ApplicationController
  before_action :authenticate_user!
  before_action :sudo_can_see_all_folders, only: [:show]
  before_action :sudo_role_can_folder_settings, only: [:edit, :update]

  def show
      @view_casts_count = @folder.view_casts.where.not(template_card_id: TemplateCard.to_story_cards_ids).count
      @view_casts = @folder.view_casts.where.not(template_card_id: TemplateCard.to_story_cards_ids).order(updated_at: :desc).page(params[:page]).per(30)
      @is_viewcasts_present = @view_casts.count != 0
      @activities = @account.activities.where(folder_id: @folder.id).order("updated_at DESC").limit(30)
      @page_count = @folder.pages.count
      @page = Page.new
      render layout: "application-fluid"
  end

  def new
    @folder = @account.folders.new()
  end

  def edit
    if @folder.is_trash
      redirect_back(fallback_location: [@account], alert: t("pd.folder"))
    end
    @folder.collaborator_lists = @folder.users.pluck(:id)
  end

  def update
    folder_params[:updated_by] = current_user.id
    if @folder.update(folder_params)
      track_activity(@folder)
      redirect_to account_site_folder_path(@account, @site, @folder), notice: t("us")
    else
      render "edit"
    end
  end

  def create
    @folder = @account.folders.new(folder_params)
    @folder.created_by = current_user.id
    @folder.updated_by = current_user.id
    @stream.collaborator_lists << current_user.id if @permission_role == 'contributor'
    if @folder.save
      track_activity(@folder)
      redirect_to account_site_folder_path(@account, @site, @folder), notice: t("cs")
    else
      render "new"
    end
  end

  private

    def folder_params
      params.require(:folder).permit(:account_id, :name, :created_by, :updated_by, :site_id, :is_open, collaborator_lists: [])
    end

end
