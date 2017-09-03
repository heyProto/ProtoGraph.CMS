class StreamsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_stream, only: [:show, :edit, :update, :publish]

    def index
        @streams = @folder.streams
        @stream = @folder.streams.new
    end

    def create
        @stream = @folder.streams.new(stream_params)
        @stream.created_by = current_user.id
        @stream.updated_by = current_user.id
        if @stream.save
            redirect_to account_folder_stream_path(@account, @folder, @stream), notice: t('cs')
        else
            render :new
        end
    end

    def new
        @stream = @folder.streams.new(account_id: @account.id)
    end

    def show
        @view_casts = @stream.cards
        @folders = @account.folders.where(id: @stream.folder_list)
        @template_cards = @account.template_cards.where(id: @stream.card_list)
    end

    def edit
        @stream.folder_list = @stream.folder_ids.pluck(:entity_value)
        @stream.card_list = @stream.template_card_ids.pluck(:entity_value)
    end

    def update
        s_params = stream_params
        s_params[:updated_by] = current_user.id
        if @stream.update(s_params)
            redirect_to account_folder_stream_path(@account, @folder, @stream), notice: t('cs')
        else
            render :edit
        end
    end

    def publish
        Thread.new do
            @stream.publish_cards
            ActiveRecord::Base.connection.close
        end
        redirect_to account_folder_stream_path(@account, @folder, @stream), notice: t("published.stream")
    end

    private

    def stream_params
        params.require(:stream).permit(:account_id, :folder_id, :title, :description, :created_by, :updated_by, :limit, :offset,card_list: [], folder_list: [], tag_list: [])
    end

    def set_stream
        @stream = @folder.streams.friendly.find(params[:id])
    end
end