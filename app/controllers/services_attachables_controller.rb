class ServicesAttachablesController < ApplicationController
  before_action :set_services_attachable, only: [:upload_file, :file, :destroy]

  def upload_file
    if services_attachable_params.has_key?(:binary_file)
      binary_file = services_attachable_params[:binary_file]
      encoded_file = Base64.encode64(File.read(binary_file.tempfile))
      content_type = binary_file.content_type
      original_file_name = binary_file.original_filename
      key = "files/#{@account.slug}/#{@services_attachable.attachable.global_slug}/#{@services_attachable.genre}/#{original_file_name}"
      resp = Api::Haiku::Utility.upload_to_cdn(encoded_file, key, content_type)
      s3_url = resp.first["s3_endpoint"]
      @services_attachable.update_attributes(file_url: s3_url, original_file_name: original_file_name, updated_by: current_user.id)
      redirect_back(fallback_location: root_path, notice: t("us"))
    else
      redirect_back(fallback_location: root_path, alert: t("param.required", param: "file"))
    end
  end

  def file
    Api::Haiku::Utility.remove_from_cdn(@services_attachable.file_url)
    @services_attachable.update_attributes(file_url: nil, original_file_name: nil, updated_by: current_user.id)
    redirect_back(fallback_location: root_path, notice: t("removed_file"))
  end

  def destroy
    @services_attachable.destroy
    respond_to do |format|
      format.html { redirect_to services_attachables_url, notice: 'Services attachable was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_services_attachable
      @services_attachable = ServicesAttachable.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def services_attachable_params
      params.require(:services_attachable).permit(:account_id, :attachable_id, :attachable_type, :genre, :file_url, :original_file_name, :file_type, :s3_bucket, :created_by, :updated_by, :binary_file)
    end
end
