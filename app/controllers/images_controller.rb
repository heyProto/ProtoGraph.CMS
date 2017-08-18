class ImagesController < ApplicationController
  # before_filter :find_model

  def index
    @images = Image.all
    @image = Image.new
  end

  def create
    @image = Image.new(image_params)
    if @image.save
      redirect_to account_images_path(@account), notice: "Image added successfully"
    else
      redirect_to account_images_path(@account), alert: "Failed to add the image"
    end
  end

  def show
  end

  def update
  end

  private

  def set_image
    @image = Images.find(params[:id]) if params[:id]
  end

  def image_params
    params.require(:image).permit(:account_id, :image, :name, :description, :tags)
  end
end