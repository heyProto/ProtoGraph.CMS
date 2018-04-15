class StreamsController < ApplicationController
    before_action :authenticate_user!
    before_action :sudo_can_see_all_streams, only: [:show, :edit, :update]
    before_action :set_stream, only: [:show, :edit, :update, :destroy, :publish]

    def create
        @stream = @folder.streams.new(stream_params)
        @stream.created_by = current_user.id
        @stream.updated_by = current_user.id
        @stream.collaborator_lists = ["#{current_user.id}"] if ["contributor", "writer"].include?(@permission_role.slug)
        if @stream.save
            track_activity(@stream)
            redirect_to account_site_stream_path(@account, @site, @stream, folder_id: @folder.blank? ? nil : @folder.id), notice: t('cs')
        else
            render :new
        end
    end

    def show
        @view_casts = @stream.cards
        @folders_dropdown = @account.folders.active.where(id: @stream.folder_list)
        @template_cards = @account.template_cards.where(id: @stream.card_list)
        @is_viewcasts_present = @view_casts_count != 0
    end

    def edit
        @stream.folder_list = @stream.folder_ids.pluck(:entity_value)
        @stream.card_list = @stream.template_card_ids.pluck(:entity_value)
        @stream.view_cast_id_list = @stream.view_cast_ids.pluck(:entity_value).join(",")
        @stream.excluded_view_cast_id_list = @stream.excluded_view_cast_ids.pluck(:entity_value).join(",")
        @is_viewcasts_present = @view_casts_count != 0
    end

    def update
        s_params = stream_params
        s_params[:updated_by] = current_user.id
        if @stream.update(s_params)
            track_activity(@stream)
            if @stream.pages.first.present?
                redirect_back(fallback_location: account_site_pages_path(@account, @site, folder_id: (@folder.present? ? @folder.id : nil)), notice: t('us'))
            else
                redirect_to account_site_stream_path(@account, @site, @stream, folder_id: @folder.blank? ? nil : @folder.id), notice: t('cs')
            end
        else
            render :edit
        end
    end

    def destroy
        @stream.updator = current_user
        @stream.folder = @account.folders.find_by(name: "Trash")
        if @stream.save
            redirect_to account_site_streams_path(@account, @site, folder_id: @folder.blank? ? nil : @folder.id), notice: "Stream was deleted successfully"
        else
            redirect_to account_site_stream_path(@account, @site, @stream, folder_id: @folder.blank? ? nil : @folder.id), alert: "Stream could not be deleted"
        end
    end

    def publish
        StreamPublisher.perform_async(@stream.id)
        track_activity(@stream)
        if @stream.pages.first.present?
            redirect_back(fallback_location: account_site_pages_path(@account, @site, folder_id: (@folder.present? ? @folder.id : nil)), notice:t("published.stream"))
        else
          redirect_to account_site_stream_path(@account, @site, @stream, folder_id: @folder.blank? ? nil : @folder.id), notice: t("published.stream")
        end
    end

    private

    def stream_params
        params.require(:stream).permit(:account_id, :folder_id, :title, :description, :created_by, :updated_by, :limit, :offset, :order_by_key, :order_by_value, :include_data, :order_by_type,card_list: [], folder_list: [], view_cast_id_list: [], excluded_view_cast_id_list: [], collaborator_lists: [])
    end

    def set_stream
        @stream = Stream.friendly.find(params[:id])
    end
end
