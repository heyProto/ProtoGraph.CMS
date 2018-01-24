class StreamsController < ApplicationController
    before_action :authenticate_user!
    before_action :sudo_can_see_all_streams, only: [:show, :edit, :update]
    before_action :set_stream, only: [:show, :edit, :update, :destroy, :publish]

    def create
        @stream = @folder.streams.new(stream_params)
        @stream.created_by = current_user.id
        @stream.updated_by = current_user.id
        @stream.collaborator_lists << current_user.id if @permission_role == 'contributor'
        if @stream.save
            track_activity(@stream)
            redirect_to account_site_folder_stream_path(@account, @site, @folder, @stream), notice: t('cs')
        else
            render :new
        end
    end

    def new
        @stream = @folder.streams.new(account_id: @account.id)
        @view_casts_count = @folder.view_casts.count
        @streams_count = @folder.streams.count
        @view_casts_id_list = []
        @is_viewcasts_present = @view_casts_count != 0
        render layout: "application-fluid"
    end

    def show
        @view_casts = @stream.cards
        @folders = @account.folders.where(id: @stream.folder_list)
        @view_casts_count = @folder.view_casts.count
        @template_cards = @account.template_cards.where(id: @stream.card_list)
        @is_viewcasts_present = @view_casts_count != 0
        @streams_count = @folder.streams.count
        render layout: "application-fluid"
    end

    def edit
        @stream.folder_list = @stream.folder_ids.pluck(:entity_value)
        @stream.card_list = @stream.template_card_ids.pluck(:entity_value)
        @stream.view_cast_id_list = @stream.view_cast_ids.pluck(:entity_value).join(",")
        @stream.excluded_view_cast_id_list = @stream.excluded_view_cast_ids.pluck(:entity_value).join(",")
        @view_casts_count = @folder.view_casts.count
        @streams_count = @folder.streams.count
        @is_viewcasts_present = @view_casts_count != 0
        render layout: "application-fluid"
    end

    def update
        s_params = stream_params
        s_params[:updated_by] = current_user.id
        if @stream.update(s_params)
            track_activity(@stream)
            redirect_to account_site_folder_stream_path(@account, @site, @folder, @stream), notice: t('cs')
        else
            render :edit
        end
    end

    def destroy
        @stream.updator = current_user
        @stream.folder = @account.folders.find_by(name: "Recycle Bin")
        if @stream.save
            redirect_to account_site_folder_streams_path(@account, @site, @folder), notice: "Stream was deleted successfully"
        else
            redirect_to account_site_folder_stream_path(@account, @site, @folder, @stream), alert: "Stream could not be deleted"
        end
    end

    def publish
        Thread.new do
            @stream.publish_cards
            track_activity(@stream)
            ActiveRecord::Base.connection.close
        end
        redirect_to account_site_folder_stream_path(@account, @site, @folder, @stream), notice: t("published.stream")
    end

    private

    def stream_params
        params.require(:stream).permit(:account_id, :folder_id, :title, :description, :created_by, :updated_by, :limit, :offset, :order_by_key, :order_by_value, :include_data, :order_by_type,card_list: [], folder_list: [], view_cast_id_list: [], excluded_view_cast_id_list: [])
    end

    def set_stream
        @stream = @folder.streams.friendly.find(params[:id])
    end
end
