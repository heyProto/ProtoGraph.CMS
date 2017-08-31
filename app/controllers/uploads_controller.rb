class UploadsController < ApplicationController

  before_action :set_upload, only: [:show]

  def new
    @upload = Upload.new
    @template_cards = TemplateCard.all
  end

  def create
    @upload = Upload.new(upload_params)
    if @upload.save
    # redirect_to root_url, notice: "File was uploaded successfully"
    else
      redirect_to root_url, alert: @upload.errors.full_messages
    end
  end

  def show
  end
  private
  def upload_params
    params.require(:upload).permit(:attachment,
                                   :template_card_id)
  end

  def set_upload
    @upload = Upload.find(params[:id])
  end
end
