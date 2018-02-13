class UploadsController < ApplicationController
  before_action :authenticate_user!
  before_action :sudo_pykih_admin
  before_action :set_upload, only: [:show]

  def index
    @upload = Upload.new
    @folders_dropdown = @account.folders
    @template_cards = @account.template_cards.with_multiple_uploads
    @uploads = @folder.uploads.order("created_at DESC")
  end

  def create
    @upload = Upload.new(upload_params)
    if !@upload.validate_headers
      redirect_to account_site_folder_uploads_path(@account, @site, @folder), alert: "Make sure headers are the same as in the CSV headers file and you have selected the right card type" and return
    end
    @upload.folder = Folder.find(upload_params[:folder_id])
    @upload.creator = current_user
    @upload.updator = current_user
    @upload.account = @account
    if @upload.save
      redirect_to account_site_folder_uploads_path(@account, @site, @folder), notice: "File was uploaded successfully"
    else
      redirect_to account_site_folder_uploads_path(@account, @site,@folder), alert: @upload.errors.full_messages
    end
  end

  private
  def upload_params
    params.require(:upload).permit(:attachment,
                                   :template_card_id,
                                   :account_id,
                                   :folder_id,:site_id, :upload_status)
  end

  def set_upload
    @upload = Upload.find(params[:id])
  end
end
