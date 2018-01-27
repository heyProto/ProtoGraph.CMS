class PagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_page, only: [:show, :edit, :update, :destroy]
  before_action :sudo_can_see_all_pages, only: [:show, :edit, :update]

  def index
    @pages = @permission_role.can_see_all_pages ? @folder.pages.where.not(template_page_id: TemplatePage.where(name: "section").pluck(:id).uniq).order(updated_at: :desc).page(params[:page]).per(30) : current_user.pages(@folder).where.not(template_page_id: TemplatePage.where(name: "section").pluck(:id).uniq).order(updated_at: :desc).page(params[:page]).per(30)
  end
  
  def manager
    @pages = @site.pages.where(template_page_id: TemplatePage.where(name: "section").pluck(:id).uniq)
  end

  def show
    redirect_to edit_account_site_folder_page_path(@account, @site, @folder, @page)
  end

  def new
    @page = Page.new
    @ref_series = RefCategory.where(site_id: @site.id, genre: "series", is_disabled: [false, nil]).order(:name).map {|r| ["#{r.name}", r.id]}
    @ref_intersection = RefCategory.where(site_id: @site.id, genre: "intersection", is_disabled: [false, nil]).order(:name).map {|r| ["#{r.name}", r.id]}
    @ref_sub_intersection = RefCategory.where(site_id: @site.id, genre: "sub intersection", is_disabled: [false, nil]).order(:name).map {|r| ["#{r.name}", r.id]}
    @layout = TemplatePage.all.map {|r| [ "#{r.name.titlecase}", r.id ]}
    @cover_image_alignment = ['vertical', 'horizontal'].map {|r| ["#{r.titlecase}", r]}
  end

  def edit
    @ref_series = RefCategory.where(site_id: @site.id, genre: "series", is_disabled: [false, nil]).order(:name).map {|r| ["#{r.name}", r.id]}
    @ref_intersection = RefCategory.where(site_id: @site.id, genre: "intersection", is_disabled: [false, nil]).order(:name).map {|r| ["#{r.name}", r.id]}
    @ref_sub_intersection = RefCategory.where(site_id: @site.id, genre: "sub intersection", is_disabled: [false, nil]).order(:name).map {|r| ["#{r.name}", r.id]}
    @cover_image_alignment = ['vertical', 'horizontal'].map {|r| ["#{r.titlecase}", r]}
    @view_cast = @page.view_cast if @page.view_cast_id.present?
    @page_streams = @page.page_streams
  end

  def create
    @page = Page.new(page_params)
    @page.created_by = current_user.id
    @page.updated_by = current_user.id
    @page.collaborator_lists = ["#{current_user.id}"] if ["contributor", "writer"].include?(@permission_role.slug)
    if @page.save
      redirect_to account_site_folder_pages_path(@account, @site, @folder), notice: 'Page was successfully created.'
    else
      @ref_series = RefCategory.where(site_id: @site.id, genre: "series", is_disabled: [false, nil]).order(:name).map {|r| ["#{r.name}", r.id]}
      @ref_intersection = RefCategory.where(site_id: @site.id, genre: "intersection", is_disabled: [false, nil]).order(:name).map {|r| ["#{r.name}", r.id]}
      @ref_sub_intersection = RefCategory.where(site_id: @site.id, genre: "sub intersection", is_disabled: [false, nil]).order(:name).map {|r| ["#{r.name}", r.id]}
      @layout = TemplatePage.all.map {|r| [ "#{r.name.titlecase}", r.id ]}
      @cover_image_alignment = ['vertical', 'horizontal'].map {|r| ["#{r.titlecase}", r]}
      render :new, alert: @page.errors.full_messages
    end
  end

  def update
    @page.updated_by = current_user.id
    respond_to do |format|
      if @page.update_attributes(page_params)
        format.json { respond_with_bip(@page) }
        format.html { redirect_to account_site_folder_page_path(@account, @site, @folder, @page), notice: 'Page was successfully updated.' }
      else
        format.json { respond_with_bip(@page) }
        format.html { render :action => "edit", alert: @page.errors.full_messages }
      end
    end
  end

  def destroy
    @page.destroy
    redirect_to account_site_folder_pages_path(@account,@site, @folder), notice: 'Page was successfully destroyed.'
  end

  private

    def set_page
      @page = Page.find(params[:id])
    end

    def page_params
      params.require(:page).permit(:id, :account_id, :site_id, :folder_id, :headline, :meta_keywords, :meta_description, :summary, :template_page_id, :byline, :byline_stream, :cover_image_url, :cover_image_url_7_column, :cover_image_url_facebook, :cover_image_url_square, :cover_image_alignment, :is_sponsored, :is_interactive, :has_data, :has_image_other_than_cover, :has_audio, :has_video, :is_published, :published_at, :url, :ref_category_series_id, :ref_category_intersection_id, :ref_category_sub_intersection_id, :view_cast_id, :page_object_url, :created_by, :updated_by, collaborator_lists: [])
    end
end
