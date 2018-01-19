class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  def index
    @pages = Page.all
  end

  def show
  end

  def new
    @page = Page.new
  end

  def edit
  end

  def create
    @page = Page.new(page_params)
    @page.created_by = current_user.id
    @page.updated_by = current_user.id
    if @page.save
      redirect_to @page, notice: 'Page was successfully created.'
    else
      render :new
    end
  end

  def update
    @page.updated_by = current_user.id
    if @page.update(page_params)
      redirect_to @page, notice: 'Page was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @page.destroy
    redirect_to pages_url, notice: 'Page was successfully destroyed.'
  end

  private

    def set_page
      @page = Page.find(params[:id])
    end

    def page_params
      params.require(:page).permit(:id, :account_id, :site_id, :folder_id, :headline, :meta_tags, :meta_description, :summary, :layout, 
                                   :byline, :byline_stream, :cover_image_url, :cover_image_url_7_column, :cover_image_url_facebook, 
                                   :cover_image_url_square, :cover_image_alignment, :is_sponsored, :is_interactive, :has_data, 
                                   :has_image_other_than_cover, :has_audio, :has_video, :is_published, :published_at, :url, 
                                   :ref_category_series_id, :ref_category_intersection_id, :ref_category_sub_intersection_id, 
                                   :view_cast_id, :page_object_url, :created_by, :updated_by)
    end
end
