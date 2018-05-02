class AdIntegrationsController < ApplicationController
    before_action :authenticate_user!, :set_page
    before_action :set_ad_integration, except: [:create]

    def create
        @ad_integration = @page.ad_integrations.new(ad_integration_params)
        @ad_integration.created_by = current_user.id
        @ad_integration.updated_by = current_user.id
        if @ad_integration.save
            PagePublisher.perform_async(@page.id)
            redirect_back(fallback_location: root_url, notice: "Added Successfully.")
        else
            redirect_back(fallback_location: root_url, alert: "Something went wrong.")
        end
    end

    def destroy
        @ad_integration.destroy
        PagePublisher.perform_async(@page.id)
        redirect_back(fallback_location: root_url, notice: "Removed Successfully.")
    end

    private

    def ad_integration_params
        params.require(:ad_integration).permit(:account_id, :site_id, :stream_id, :page_id, :sort_order, :div_id, :width, :height, :slot_text, :page_stream_id)
    end

    def set_page
        @page = @site.pages.friendly.find(params[:page_id])
    end

    def set_ad_integration
        @ad_integration = AdIntegration.find(params[:id])
    end


end