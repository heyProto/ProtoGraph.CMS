class PagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_page, only: [:show, :edit, :update, :destroy]
  before_action :sudo_can_see_all_pages, only: [:show, :edit, :update, :manager]

  def index
    @pages = @permission_role.can_see_all_pages ? @folder.pages.where.not(template_page_id: TemplatePage.where(name: "section").pluck(:id).uniq).order(updated_at: :desc).page(params[:page]).per(30) : current_user.pages(@folder).where.not(template_page_id: TemplatePage.where(name: "section").pluck(:id).uniq).order(updated_at: :desc).page(params[:page]).per(30)
  end

  def manager
    @genre = "series"
    @data = @site.verticals.order(:name)
    @instance = @site.verticals.new
  end

  def show
    redirect_to edit_account_site_page_path(@account, @site, @page)
  end

  def new
    @page = Page.new
    @ref_series = RefCategory.where(site_id: @site.id, genre: "series", is_disabled: [false, nil]).order(:name).map {|r| ["#{r.name}", r.id]}
    @ref_intersection = RefCategory.where(site_id: @site.id, genre: "intersection", is_disabled: [false, nil]).order(:name).map {|r| ["#{r.name}", r.id]}
    @ref_sub_intersection = RefCategory.where(site_id: @site.id, genre: "sub intersection", is_disabled: [false, nil]).order(:name).map {|r| ["#{r.name}", r.id]}
    @layout = TemplatePage.where.not(name: "Homepage: Vertical").map {|r| [ "#{r.name.titlecase}", r.id ]}
    @cover_image_alignment = ['vertical', 'horizontal'].map {|r| ["#{r.titlecase}", r]}
    @article = TemplatePage.where(name: "article").first
  end

  def edit
    @ref_series = RefCategory.where(site_id: @site.id, genre: "series", is_disabled: [false, nil]).order(:name).map {|r| ["#{r.name}", r.id]}
    @ref_intersection = RefCategory.where(site_id: @site.id, genre: "intersection", is_disabled: [false, nil]).order(:name).map {|r| ["#{r.name}", r.id]}
    @ref_sub_intersection = RefCategory.where(site_id: @site.id, genre: "sub intersection", is_disabled: [false, nil]).order(:name).map {|r| ["#{r.name}", r.id]}
    @cover_image_alignment = ['vertical', 'horizontal'].map {|r| ["#{r.titlecase}", r]}
    @view_cast = @page.view_cast if @page.view_cast_id.present?
    @page_streams = @page.page_streams

    if @page.template_page.name == "article"
      @page_stream_narrative = @page.streams.where(title: "#{@page.id.to_s}_Story_Narrative").first
      @page_stream_narrative.view_cast_id_list = @page_stream_narrative.view_cast_ids.pluck(:entity_value).join(",")
      @page_stream_related = @page.streams.where(title: "#{@page.id.to_s}_Story_Related").first
      @page_stream_related.view_cast_id_list = @page_stream_related.view_cast_ids.pluck(:entity_value).join(",")
    elsif @page.template_page.name == "Homepage: Vertical"
      @page_stream_16 = @page.streams.where(title: "#{@page.id.to_s}_Section_16c_Hero").first
      @page_stream_16.view_cast_id_list = @page_stream_16.view_cast_ids.pluck(:entity_value).join(",")
      @page_stream_07 = @page.streams.where(title: "#{@page.id.to_s}_Section_7c").first
      @page_stream_07.view_cast_id_list = @page_stream_07.view_cast_ids.pluck(:entity_value).join(",")
      @page_stream_04 = @page.streams.where(title: "#{@page.id.to_s}_Section_4c").first
      @page_stream_04.view_cast_id_list = @page_stream_04.view_cast_ids.pluck(:entity_value).join(",")
      @page_stream_03 = @page.streams.where(title: "#{@page.id.to_s}_Section_3c").first
      @page_stream_03.view_cast_id_list = @page_stream_03.view_cast_ids.pluck(:entity_value).join(",")
      @page_stream_02 = @page.streams.where(title: "#{@page.id.to_s}_Section_2c").first
      @page_stream_02.view_cast_id_list = @page_stream_02.view_cast_ids.pluck(:entity_value).join(",")
      @page_streamH16 = @page_stream_16.page_streams.where(page_id: @page.id).first
      @page_streamH07 = @page_stream_07.page_streams.where(page_id: @page.id).first
      @page_streamH04 = @page_stream_04.page_streams.where(page_id: @page.id).first
      @page_streamH03 = @page_stream_03.page_streams.where(page_id: @page.id).first
      @page_streamH02 = @page_stream_02.page_streams.where(page_id: @page.id).first
    end
  end

  def create
    @page = Page.new(page_params)
    @page.created_by = current_user.id
    @page.updated_by = current_user.id
    @page.collaborator_lists = ["#{current_user.id}"] if ["contributor", "writer"].include?(@permission_role.slug)
    if @page.save
      redirect_to account_site_pages_path(@account, @site, folder_id: @page.folder.id), notice: 'Page was successfully created.'
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
        format.html {
          if @page.folder.present?
            redirect_to account_site_pages_path(@account, @site, folder_id: @page.folder.id), notice: 'Page was successfully updated.'
          else
            redirect_to manager_account_site_path(@account, @site), notice: 'Page was successfully updated.'
          end
        }
      else
        format.json { respond_with_bip(@page) }
        format.html { render :action => "edit", alert: @page.errors.full_messages }
      end
    end
  end

  def destroy
    f = @page.folder_id
    @page.destroy
    redirect_to account_site_pages_path(@account, @site, folder_id: f), notice: 'Page was successfully destroyed.'
  end

  private

    def set_page
      @page = Page.friendly.find(params[:id])
    end

    def page_params
      params.require(:page).permit(:id, :account_id, :site_id, :folder_id, :headline, :meta_keywords, :meta_description, :summary, :template_page_id, :byline, :byline_stream, :cover_image_url, :cover_image_url_7_column, :cover_image_url_facebook, :cover_image_url_square, :cover_image_alignment, :is_sponsored, :is_interactive, :has_data, :has_image_other_than_cover, :has_audio, :has_video, :is_published, :published_at, :url, :ref_category_series_id, :ref_category_intersection_id, :ref_category_sub_intersection_id, :view_cast_id, :page_object_url, :created_by, :updated_by, :english_headline,collaborator_lists: [])
    end
end
