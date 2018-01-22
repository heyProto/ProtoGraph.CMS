class RefCategoriesController < ApplicationController

  before_action :authenticate_user!
  # before_action :sudo_role_can_account_settings, only: [:edit, :update]
  before_action :set_entity, only: [:update, :destroy, :disable]


  def series
    @genre = "series"
    @data = @site.ref_categories.where(genre: "series").order(:name)
    @instance = RefCategory.new
    render :index
  end

  def intersection
    @genre = "intersection"
    @data = @site.ref_categories.where(genre: "intersection").order(:name)
    @instance = RefCategory.new
    render :index
  end

  def sub_intersection
    @genre = "sub intersection"
    @data = @site.ref_categories.where(genre: "sub intersection").order(:name)
    @instance = RefCategory.new
    render :index
  end

  def tag
    @genre = "tag"
    @data = @site.ref_tags.order(:name)
    @instance = RefTag.new
    render :index
  end

  def create
    if entity_params[:genre] != 'tag'
      @ref_category = RefCategory.new(entity_params)
    else
      @ref_category = RefTag.new(entity_params)
    end
    @ref_category.created_by = current_user.id
    @ref_category.updated_by = current_user.id
      if @ref_category.save
        @notice = 'Created successfully.'
        custom_redirect_to
      else
        case @ref_category.genre
        when 'series'
          redirect_to series_account_site_path(@account, @site), alert: @ref_category.errors.full_messages
        when 'intersection'
          redirect_to intersection_account_site_path(@account, @site), alert: @ref_category.errors.full_messages
        when 'sub intersection'
          redirect_to sub_intersection_account_site_path(@account, @site), alert: @ref_category.errors.full_messages
        when 'tag'
          redirect_to tag_account_site_path(@account, @site), alert: @ref_category.errors.full_messages
        end
      end
  end

  def update
    respond_to do |format|
      if @ref_category.update_attributes(entity_params)
        @notice = 'Updated successfully.'
        format.json { respond_with_bip(@ref_category) }
        format.html { custom_redirect_to }
      else
        format.json { respond_with_bip(@ref_category) }
        format.html { render :action => "edit" }
      end
    end
  end

  def disable
    @ref_category.update_attributes(is_disabled: true, updated_by: current_user.id)
    @notice = 'Ref category was successfully disabled.'
    custom_redirect_to
  end

  def destroy
    @genre = @ref_category.genre
    @ref_category.destroy
    respond_to do |format|
        case @genre
        when 'series'
          format.html { redirect_to series_account_site_path(@account, @site), notice: "Destroyed"}
        when 'intersection'
          format.html { redirect_to intersection_account_site_path(@account, @site), notice: "Destroyed"}
        when 'sub intersection'
          format.html { redirect_to sub_intersection_account_site_path(@account, @site), notice: "Destroyed"}
        else 'tag'
          format.html { redirect_to tag_account_site_path(@account, @site), notice: "Destroyed"}
        end
    end
  end

  def custom_redirect_to
    case @ref_category.genre
    when 'series'
      redirect_to series_account_site_path(@account, @site), notice: @notice
    when 'intersection'
      redirect_to intersection_account_site_path(@account, @site), notice: @notice
    when 'sub intersection'
      redirect_to sub_intersection_account_site_path(@account, @site), notice: @notice
    else
      redirect_to tag_account_site_path(@account, @site), notice: @notice
    end
  end

  private

    def set_entity
      @ref_category = RefCategory.find(params[:id])
    end

    def entity_params
      if params[:ref_category].present?
        params.require(:ref_category).permit(:site_id, :genre, :name, :name_html, :is_disabled, :created_by, :updated_by)
      else
        params.require(:ref_tag).permit(:site_id, :genre, :name, :is_disabled, :created_by, :updated_by)
      end
    end
end
