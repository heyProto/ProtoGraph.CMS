class StreamEntitiesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_stream


    def create
        @stream_entity = @stream.stream_entities.new(stream_entity_params)
        if @stream_entity.save
            redirect_back(fallback_location: root_url, notice: "Added Successfully.")
        else
            s
            redirect_back(fallback_location: root_url, notice: "Something went wrong.")
        end
    end

    def destroy
        @stream_entity = StreamEntity.find(params[:id])
        @stream_entity.destroy
        redirect_back(fallback_location: root_url, notice: "Removed Successfully.")
    end

    private

    def stream_entity_params
        params.require(:stream_entity).permit(:stream_id, :entity_type, :entity_value, :is_excluded)
    end

    def set_stream
        @stream = @site.streams.friendly.find(params[:stream_id])
    end


end