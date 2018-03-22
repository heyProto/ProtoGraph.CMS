class StreamEntitiesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_stream
    before_action :set_stream_entity, except: [:create]

    def create
        @stream_entity = @stream.stream_entities.new(stream_entity_params)
        if @stream_entity.save
            StreamPublisher.perform_async(@stream.id)
            @stream.pages.each do |p|
                PagePublisher.perform_async(p.id)
            end
            redirect_back(fallback_location: root_url, notice: "Added Successfully.")
        else
            redirect_back(fallback_location: root_url, notice: "Something went wrong.")
        end
    end

    def destroy
        old_sort_order = @stream_entity.sort_order
        @stream_entity.destroy
        @stream.view_cast_ids.where("sort_order > ?", old_sort_order).update_all("sort_order = sort_order - 1")
        StreamPublisher.perform_async(@stream.id)
        @stream.pages.each do |p|
            PagePublisher.perform_async(p.id)
        end
        redirect_back(fallback_location: root_url, notice: "Removed Successfully.")
    end

    def move_up
        old_sort_order = @stream_entity.sort_order
        old_stream_entity = @stream.view_cast_ids.where(stream_id: @stream.id, sort_order: (old_sort_order - 1)).first
        old_stream_entity.update(sort_order: old_sort_order) if old_stream_entity.present?
        @stream_entity.sort_order = @stream_entity.sort_order.to_i - 1
        @stream_entity.save!
        StreamPublisher.perform_async(@stream.id)
        @stream.pages.each do |p|
            PagePublisher.perform_async(p.id)
        end
        redirect_back(fallback_location: root_url)
    end

    def move_down
        old_sort_order = @stream_entity.sort_order
        old_stream_entity = @stream.view_cast_ids.where(sort_order: (old_sort_order + 1)).first
        old_stream_entity.update(sort_order: old_sort_order) if old_stream_entity.present?
        @stream_entity.sort_order = @stream_entity.sort_order.to_i + 1
        @stream_entity.save!
        StreamPublisher.perform_async(@stream.id)
        @stream.pages.each do |p|
            PagePublisher.perform_async(p.id)
        end
        redirect_back(fallback_location: root_url)
    end

    private

    def stream_entity_params
        params.require(:stream_entity).permit(:stream_id, :entity_type, :entity_value, :is_excluded, :page_id, :remove_stream_entity_id)
    end

    def set_stream
        @stream = @site.streams.friendly.find(params[:stream_id])
    end

    def set_stream_entity
        @stream_entity = StreamEntity.find(params[:id])
    end


end