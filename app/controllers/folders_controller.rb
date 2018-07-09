class FoldersController < ApplicationController
  before_action :authenticate_user!
  before_action :sudo_role_can_folder_settings, only: [:edit, :update]
  
  def index
    @folders = @permission_role.can_see_all_folders ? @site.folders : current_user.folders(@site)
    
  end

  def new
    # TODO: Do not allow to create workspace if vertical is empty
    @folder = @site.folders.new
    @folder.is_for_stories = true
    @verticals = @site.ref_categories.where(genre: 'series').pluck(:name, :id)
    
  end
  
  def show
    if @folder.is_for_stories
      redirect_to site_stories_path(@site,folder_id: @folder.id)
    else
      redirect_to site_folder_view_casts_path(@site, @folder)
    end
  end

  def edit
    if @folder.is_trash
      redirect_back(fallback_location: [@site], alert: t("pd.folder"))
    end
    @folder.collaborator_lists = @folder.users.pluck(:id)
    @verticals = @site.ref_categories.where(genre: 'series').pluck(:name, :id)
    
  end

  def update
    folder_params[:updated_by] = current_user.id
    if @folder.update(folder_params)
      redirect_to site_folder_view_casts_path(@site, @folder), notice: t("us")
    else
      @verticals = @site.ref_categories.where(genre: 'series').pluck(:name, :id)
      @folder.collaborator_lists = @folder.users.pluck(:id)
      @is_admin = true
      render "edit", layout: "z"
    end
  end

  def create
    if params["folder"]["ref_category_vertical_id"].blank? and params["folder"]["is_for_stories"]
      redirect_to new_site_folder_path(@site), alert: "You must associate a vertical to add stories in workspace"
    else
      @folder = @site.folders.new(folder_params)
      @folder.created_by = current_user.id
      @folder.updated_by = current_user.id
      @folder.collaborator_lists = ["#{current_user.id}"] if ["contributor", "writer"].include?(@permission_role.slug)
      if @folder.save
        redirect_to site_folder_view_casts_path(@site, @folder), notice: t("cs")
      else
        @is_admin = true
        @verticals = @site.ref_categories.where(genre: 'series').pluck(:name, :id)
        render "new", layout: "z"
      end
    end
  end

  private

    def folder_params
      params.require(:folder).permit(:site_id, :name, :created_by, :updated_by, :is_archived, :is_open,
                                    :ref_category_vertical_id, :is_for_stories, collaborator_lists: [])
    end

end