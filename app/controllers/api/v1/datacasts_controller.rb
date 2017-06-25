class Api::V1::DatacastsController < ApiController

    def create
        payload = {}
        payload["payload"] = datacast_params.to_json
        payload["source"]  = "form"
        view_cast = @account.view_casts.new(view_cast_params)
        view_cast.created_by = @user.id
        view_cast.updated_by = @user.id
        if view_cast.save
            payload["api_slug"] = view_cast.datacast_identifier
            payload["schema_url"] = view_cast.template_datum.schema_json
            r = Api::ProtoGraph::Datacast.create(payload)
            if r.has_key?("errorMessage")
                view_cast.remove_file
                view_cast.destroy
                render json: {error_message: r['errorMessage']}, status: 422
            else
                render json: {view_cast: view_cast.as_json(methods: [:remote_urls]), redirect_path: account_view_cast_url(@account, view_cast) }, status: 200
            end

        else
            render json: {error_message: view_cast.errors.messages}, status: 422
        end
    end

    def update
        view_cast = ViewCast.friendly.find(params[:id])
        payload = {}
        payload["payload"] = datacast_params.to_json
        payload["source"]  = "form"
        payload["api_slug"] = view_cast.datacast_identifier
        payload["schema_url"] = view_cast.template_datum.schema_json
        r = Api::ProtoGraph::Datacast.update(payload)
        if r.has_key?("errorMessage")
            render json: {error_message: JSON.parse(r['errorMessage'])['Error']}, status: 422
        else
            view_cast.updated_by = @user.id
            view_cast.update_attributes(view_cast_params)
            render json: {view_cast: view_cast.as_json(methods: [:remote_urls]), redirect_path: account_view_cast_url(@account, view_cast) }, status: 200
        end
    end

    private

    def datacast_params
        params.require(:datacast)
    end

    def view_cast_params
        params.require(:view_cast).permit(:template_datum_id, :name, :template_card_id, :optionalConfigJSON, :account_id, :updated_by, :seo_blockquote)
    end

end
