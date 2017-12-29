class ImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_image, only: [:show]

  def index
    @q = @account.images.ransack(params[:q])
    @tags = Tag.all
    if params[:q].present?
      @images = @q.result(distinct: true).order(:created_at).page params[:page]
    else
      @images = @account.images.order(:created_at).page params[:page]
    end
    @new_image = Image.new
    render layout: "application-fluid"
  end

  def create
    options = image_params
    # tag_list = params["image"]["tag_list"].reject { |c| c.empty? }

    # if tag_list.present?
    #   options[:tag_list] = tag_list
    # end
    options[:created_by] = current_user.id
    @image = Image.new(options)

    respond_to do |format|
      if @image.save
        track_activity(@image)
        format.json { render json: {success: true, data: @image}, status: 200 }
        format.html { redirect_to account_images_path(@account), notice: 'Image added successfully' }
      else
        format.json { render json: {success: false, errors: @image.errors.full_messages }, status: 400 }
        format.html { redirect_to account_images_path(@account), alert: @image.errors.full_messages }
      end
    end
  end

  def show
    @tags = Tag.all
    @new_image = Image.new
    @image_variation = ImageVariation.new
    render layout: "application-fluid"
    @activities = @image.activities.order("updated_at DESC").limit(30)
  end

  private

  def set_image
    @image = @account.images.find(params[:id])
  end

  def image_params
    params.require(:image).permit(:account_id, :image, :name, :description, :tags_list, :crop_x, :crop_y, :crop_w, :crop_h, :dominant_colour, :colour_palette)
  end
end
