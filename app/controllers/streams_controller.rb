class StreamsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_stream, only: [:show, :edit, :update, :publish]

    def create
        @stream = @folder.streams.new(stream_params)
        @stream.created_by = current_user.id
        @stream.updated_by = current_user.id
        if @stream.save
            track_activity(@stream)
            redirect_to account_folder_stream_path(@account, @folder, @stream), notice: t('cs')
        else
            render :new
        end
    end

    def index
      @view_casts_count = @folder.view_casts.count
      @streams_count = @folder.streams.count
      @articles_count = @folder.articles.count
      @is_viewcasts_present = @view_casts_count != 0
      @streams = @folder.streams.order(updated_at: :desc).page(params[:page]).per(30)
      render layout: "application-fluid"
    end

    def new
        @stream = @folder.streams.new(account_id: @account.id)
        @view_casts_count = @folder.view_casts.count
        @streams_count = @folder.streams.count
        @articles_count = @folder.articles.count
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
        @articles_count = @folder.articles.count
        render layout: "application-fluid"
    end

    def edit
        @stream.folder_list = @stream.folder_ids.pluck(:entity_value)
        @stream.card_list = @stream.template_card_ids.pluck(:entity_value)
        @stream.view_cast_id_list = @stream.view_cast_ids.pluck(:entity_value).join(",")
        @stream.excluded_view_cast_id_list = @stream.excluded_view_cast_ids.pluck(:entity_value).join(",")
        @view_casts_count = @folder.view_casts.count
        @streams_count = @folder.streams.count
        @articles_count = @folder.articles.count
        @is_viewcasts_present = @view_casts_count != 0
        render layout: "application-fluid"
    end

    def update
        s_params = stream_params
        s_params[:updated_by] = current_user.id
        if @stream.update(s_params)
            track_activity(@stream)
            redirect_to account_folder_stream_path(@account, @folder, @stream), notice: t('cs')
        else
            render :edit
        end
    end

    def publish
        Thread.new do
            @stream.publish_cards
            track_activity(@stream)
            ActiveRecord::Base.connection.close
        end
        redirect_to account_folder_stream_path(@account, @folder, @stream), notice: t("published.stream")
    end

    private

    def stream_params
        params.require(:stream).permit(:account_id, :folder_id, :title, :description, :created_by, :updated_by, :limit, :offset,card_list: [], folder_list: [], tag_list: [], view_cast_id_list: [], excluded_view_cast_id_list: [])
    end

    def set_stream
        @stream = @folder.streams.friendly.find(params[:id])
    end
end