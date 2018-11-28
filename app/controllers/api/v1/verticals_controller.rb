class Api::V1::VerticalsController < ApiController
    skip_before_action :set_user_from_token, :set_global_objects

    def view_casts
        @vertical = @site.verticals.friendly.find(params[:id])
        render json: @vertical.cards_as_json.to_json, status: 200
    end
end