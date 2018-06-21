class PageStreamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_page_stream, only: [:update]

  def update
    @page_stream.updated_by = current_user.id
    respond_to do |format|
      if @page_stream.update_attributes(page_stream_params)
        format.json { respond_with_bip(@page_stream) }
        format.html { redirect_to site_folder_page_path(@site, @page_stream), notice: 'Page was successfully updated.' }
      else
        format.json { respond_with_bip(@page_stream) }
        format.html { render :action => "edit", alert: @page_stream.errors.full_messages }
      end
    end
  end

  private

    def set_page_stream
      @page_stream = PageStream.find(params[:id])
    end

    def page_stream_params
      params.require(:page_stream).permit(:page_id, :stream_id, :name_of_stream)
    end
end