class StreamEntitiesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_stream


    def create
        @stream_entity = @stream.stream_entities.new(stream_entity_params)
    end

    def destroy
        @stream_entity.destroy
    end

    private

    def stream_entity_params
        params.require(:stream_entity).permit(:stream_id, :entity_type, :entity_values, :is_excluded)
    end

    def set_stream
        @stream = @folder.streams.friendly.find(params[:stream_id])
    end


end