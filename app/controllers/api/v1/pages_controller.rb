class Api::V1::PagesController < ApiController
  before_action :set_page, only: [:update]

  def create
    @page = Page.new(page_params)
    @page.folder = @folder
    @page.account = @account
    @page.site = @site
    @page.updator = @user
    @page.creator = @user
    if @page.save
        render json: {page: @page.as_json, message: "Page created successfully"}, status: 200
    else
        render json: {errors: @page.errors.as_json}, status: 422
    end
  end

  def update
    if @page.update_attributes(page_params)
      render json: {page: @page.as_json, message: "Page updated successfully"}, status: 200
    else
       render json: {errors: @page.errors.as_json}, status: 422
    end
  end

  private

  def set_page
    @page = Page.find(params[:id])
  end

  def page_params
    params.require(:page).permit(:from_api, 
                                 :id, :account_id, :site_id, :folder_id, :headline, :meta_keywords, :meta_description, :summary, :template_page_id, :byline, :one_line_concept,
                                 :cover_image_url, :cover_image_url_7_column, :cover_image_url_facebook, :cover_image_url_square, :cover_image_alignment, :content,
                                 :is_sponsored, :is_interactive, :has_data, :has_image_other_than_cover, :has_audio, :has_video, :status, :published_at, :url, 
                                 :ref_category_series_id, :ref_category_intersection_id, :ref_category_sub_intersection_id, :view_cast_id, :page_object_url, :created_by, 
                                 :updated_by, :english_headline, :due, :description, :cover_image_id_4_column, :cover_image_id_3_column, :cover_image_id_2_column, :cover_image_credit, :share_text_facebook, 
                                 :share_text_twitter, :publish,collaborator_lists: [], cover_image_attributes: [:image, :account_id, :is_cover, :created_by, :updated_by])
  end
end
