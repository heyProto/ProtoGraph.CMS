class UploadsController < ApplicationController

  before_action :set_upload, only: [:show]

  def new
    @upload = Upload.new
    @folders = @account.folders
    @template_cards = TemplateCard.with_multiple_uploads
  end

  def create
    @upload = Upload.new(upload_params)
    @upload.folder = Folder.find(upload_params[:folder_id])
    @upload.creator = current_user
    @upload.updator = current_user
    @upload.account = @account
    if @upload.save
      redirect_to account_folder_path(@account, Folder.find(upload_params[:folder_id])), notice: "File was uploaded successfully"
    else
      redirect_to account_folder_path(@account, Folder.find(upload_params[:folder_id])), alert: @upload.errors.full_messages
    end
  end

  def show
  end
  private
  def upload_params
    params.require(:upload).permit(:attachment,
                                   :template_card_id,
                                   :account_id,
                                   :folder_id,
                                   :user_id)
  end

  def set_upload
    @upload = Upload.find(params[:id])
  end
end
