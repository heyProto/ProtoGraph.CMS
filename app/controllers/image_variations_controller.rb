class ImageVariationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_image_variation, only: [:show, :download]

  def create
    options = image_variation_params
    options[:is_original] = false
    @image_variation = ImageVariation.new(options)
    if @image_variation.save
      track_activity(@image_variation)
      if params[:redirect_url].present?
        redirect_to params[:redirect_url], notice: t("social.integrated", {param: @image_variation.mode.to_s.titleize})
      else
        redirect_to account_image_path(@account, options[:image_id]), notice: "Image Variation added successfully"
      end
    else
      redirect_to account_image_path(@account, options[:image_id]), alert: "Failed to create image variation"
    end
  end

  def show
      redirect_to account_image_path(@account, @image_variation.image)
    #   @image = @image_variation.image
    # @image_variations = ImageVariation.where(image_id: @image_variation.image_id, is_original: false).where.not(id: @image_variation.id)
  end

  def download
    data = open(@image_variation.image_url)
    send_data data.read, filename: "#{params[:filename]}-#{@image_variation.mode}.png", disposition: 'attachment', stream: 'true', buffer_size: '4096'
  end

  private

  def set_image_variation
    @image_variation = ImageVariation.find(params[:id]) if params[:id]
  end


  def image_variation_params
    params.require(:image_variation).permit(:image_id, :created_by, :crop_x, :crop_y, :crop_w, :crop_h, :mode, :article_id)
  end

end
