class ImageVariationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_image_variation, only: [:show, :download]

  def create
    options = image_variation_params
    options[:is_original] = false
    options[:crop_x] = options[:crop_x].to_f
    options[:crop_y] = options[:crop_y].to_f
    options[:crop_w] = options[:crop_w].to_f
    options[:crop_h] = options[:crop_h].to_f
    options[:image_h] = options[:image_h].to_f
    options[:image_w] = options[:image_w].to_f
    @image_variation = ImageVariation.new(options)
    if @image_variation.save
      track_activity(@image_variation)
      if params[:redirect_url].present?
        redirect_to params[:redirect_url], notice: t("social.integrated", {param: @image_variation.mode.to_s.titleize})
      else
        redirect_to site_image_path(@site, options[:image_id]), notice: "Image Variation added successfully"
      end
    else
      redirect_to site_image_path(@site, options[:image_id]), alert: "Failed to create image variation"
    end
  end

  def show
      redirect_to site_image_path(@site, @image_variation.image)
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
    params.require(:image_variation).permit(:image_id, :created_by, :crop_x, :crop_y, :crop_w, :crop_h, :mode, :is_smart_cropped, :instant_output)
  end

end
