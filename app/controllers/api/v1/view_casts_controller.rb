class Api::V1::ViewCastsController < ApiController

    skip_before_action :set_user_from_token
    skip_before_action :set_global_objects

    def show
        @view_cast = ViewCast.where(id: params[:id]).first
        if @view_cast.present?
            render json: @view_cast.remote_urls, status: 200
        else
            render json: {error_message: "Not Found."}, status: 404
        end
    end
end