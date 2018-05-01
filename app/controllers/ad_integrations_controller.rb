class AdIntegrationsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_stream
    before_action :set_ad_integration, except: [:create]

    def create
        @ad_integration = @stream.ad_integrations.new(ad_integration_params)
        @ad_integration.created_by = current_user.id
        @ad_integration.updated_by = current_user.id
        if @ad_integration.save
            @stream.pages.each do |p|
                PagePublisher.perform_async(p.id)
            end
            redirect_back(fallback_location: root_url, notice: "Added Successfully.")
        else
            redirect_back(fallback_location: root_url, alert: "Something went wrong.")
        end
    end

    def destroy
        old_sort_order = @stream_entity.sort_order
        @ad_integration.destroy
        @stream.view_cast_ids.where("sort_order > ?", old_sort_order).update_all("sort_order = sort_order - 1")
        StreamPublisher.perform_async(@stream.id)
        @stream.pages.each do |p|
            PagePublisher.perform_async(p.id)
        end
        redirect_back(fallback_location: root_url, notice: "Removed Successfully.")
    end

    private

    def ad_integration_params
        params.require(:ad_integration).permit(:stream_id, )
    end

    def set_stream
        @stream = @site.streams.friendly.find(params[:stream_id])
    end

    def set_ad_integration
        @ad_integration = AdIntegration.find(params[:id])
    end


end