class UploadsController < ApplicationController
  def new
    @upload = Upload.new
    @template_cards = TemplateCard.all
  end

  def create
    @upload = Upload.new(@image_params)
    if @upload.save
      redirect_to root_url, notice: "File was uploaded successfully"
    else
      redirect_to root_url, alert: @upload.errors.full_messages
    end
  end

  private
  def image_params
    params.require(:upload).permit(:attachment,
                                   :template_card_id)
  end
end
