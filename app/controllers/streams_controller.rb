class StreamsController < ApplicationController
    before_action :authenticate_user!
    before_action :sudo_can_see_all_streams, only: [:show, :edit, :update]
    before_action :set_stream, only: [:show, :edit, :update, :destroy, :publish]

    def publish
        StreamPublisher.perform_async(@stream.id)
        if @stream.pages.first.present?
            redirect_back(fallback_location: account_site_pages_path(@site, folder_id: (@folder.present? ? @folder.id : nil)), notice:t("published.stream"))
        else
          redirect_to account_site_stream_path(@site, @stream, folder_id: @folder.blank? ? nil : @folder.id), notice: t("published.stream")
        end
    end

    private

    def stream_params
        params.require(:stream).permit(:site_id, :folder_id, :title, :description, :created_by, :updated_by, :limit, :offset, :order_by_key, :order_by_value, :include_data, :order_by_type,card_list: [], folder_list: [], view_cast_id_list: [], excluded_view_cast_id_list: [], collaborator_lists: [])
    end

    def set_stream
        @stream = Stream.friendly.find(params[:id])
    end
end
