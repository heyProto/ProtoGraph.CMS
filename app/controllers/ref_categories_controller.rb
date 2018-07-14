class RefCategoriesController < ApplicationController

  before_action :authenticate_user!
  before_action :sudo_role_can_add_site_categories, only: [:create]
  before_action :sudo_role_can_disable_site_categories, only: [:update]
  before_action :set_entity, only: [:edit, :update, :destroy, :disable, :landing_card]

  def edit
  end

  def sections
    @genre = "series"
    @data = @site.ref_categories.where(genre: "series").order(:name)
    @instance = RefCategory.new
    render :index
  end

  def intersections
    @is_admin = true
    @genre = "intersection"
    @data = @site.ref_categories.where(genre: "intersection").order(:name)
    @instance = RefCategory.new
    @is_admin = true
    render :index
  end

  def sub_intersections
    @is_admin = true
    @genre = "sub intersection"
    @data = @site.ref_categories.where(genre: "sub intersection").order(:name)
    @instance = RefCategory.new
    @is_admin = true
    render :index
  end

  def create
    @ref_category = RefCategory.new(entity_params)
    @ref_category.created_by = current_user.id
    @ref_category.updated_by = current_user.id
      if @ref_category.save
        @notice = 'Created successfully.'
        custom_redirect_to
      else
        case @ref_category.genre
        when 'series'
          redirect_to sections_site_path(@site), alert: @ref_category.errors.full_messages
        when 'intersection'
          redirect_to intersections_site_path(@site), alert: @ref_category.errors.full_messages
        when 'sub intersection'
          redirect_to sub_intersections_site_path(@site), alert: @ref_category.errors.full_messages
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
          format.html { redirect_to sections_site_path(@site), notice: "Destroyed"}
        when 'intersection'
          format.html { redirect_to intersections_site_path(@site), notice: "Destroyed"}
        when 'sub intersection'
          format.html { redirect_to sub_intersections_site_path(@site), notice: "Destroyed"}
        end
    end
  end

  def custom_redirect_to
    case @ref_category.genre
    when 'series'
      redirect_to sections_site_path(@site)
    when 'intersection'
      redirect_to intersections_site_path(@site), notice: @notice
    when 'sub intersection'
      redirect_to sub_intersections_site_path(@site), notice: @notice
    end
  end

  def landing_card
    @page = @ref_category.vertical_page
    @view_cast = @page.landing_card
    if (Time.now - @view_cast.updated_at) > 5.minute and (@view_cast.is_invalidating)
        @view_cast.update_column(:is_invalidating, false)
    end
    @view_cast_seo_blockquote = @view_cast.seo_blockquote.to_s.split('`').join('\`')
  end

  private

    def set_entity
      @ref_category = RefCategory.friendly.find(params[:id])
    end

    def entity_params
      if params[:ref_category].present?
        params.require(:ref_category).permit(:site_id, :genre, :name, :english_name,:name_html, :show_by_publisher_in_header, :is_disabled, :created_by, :updated_by, :vertical_page_url, :description, :keywords)
      end
    end
end
