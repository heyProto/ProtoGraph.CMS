class UploadsController < ApplicationController
  before_action :sudo_pykih_admin
  before_action :set_upload, only: [:show]

  def new
    @upload = Upload.new
    @folders = @account.folders
    @template_cards = TemplateCard.with_multiple_uploads
    @uploads = @folder.uploads.order("created_at DESC")
  end

  def create
    @upload = Upload.new(upload_params)
    if !@upload.validate_headers
      redirect_to new_account_folder_upload_path(@account, @folder), alert: "Make sure headers are the same as in the CSV headers file and you have selected the right card type" and return
    end
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

  private
  def upload_params
    params.require(:upload).permit(:attachment,
                                   :template_card_id,
                                   :account_id,
                                   :folder_id,)
  end

  def set_upload
    @upload = Upload.find(params[:id])
  end
end
