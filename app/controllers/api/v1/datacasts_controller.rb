class Api::V1::DatacastsController < ApiController

    def create
        payload = {}
        payload["payload"] = datacast_params.to_json
        payload["source"]  = params[:source] || "form"
        view_cast = @folder.view_casts.new(view_cast_params)
        view_cast.account_id = @account.id
        view_cast.created_by = @user.id
        view_cast.updated_by = @user.id
        if view_cast.template_card.name == 'toStory'
            view_cast.by_line = datacast_params['data']["by_line"]
            view_cast.genre = datacast_params['data']["genre"]
            view_cast.sub_genre = datacast_params['data']["subgenre"]
            view_cast.series = datacast_params['data']["series"]
        end
        if view_cast.save
            track_activity(view_cast)
            payload["api_slug"] = view_cast.datacast_identifier
            payload["schema_url"] = view_cast.template_datum.schema_json
            r = Api::ProtoGraph::Datacast.create(payload)
            if r.has_key?("errorMessage")
                view_cast.destroy
                render json: {error_message: r['errorMessage']}, status: 422
            else
                render json: {view_cast: view_cast.as_json(methods: [:remote_urls]), redirect_path: account_folder_view_cast_url(@account, @folder, view_cast) }, status: 200
            end

        else
            render json: {error_message: view_cast.errors.full_messages}, status: 422
        end
    end

    def update
        view_cast = @folder.view_casts.friendly.find(params[:id])
        payload = {}
        payload["payload"] = datacast_params.to_json
        payload["source"]  = "form"
        payload["api_slug"] = view_cast.datacast_identifier
        payload["schema_url"] = view_cast.template_datum.schema_json
        if view_cast.template_card.name == 'toStory'
            view_cast.by_line = datacast_params['data']["by_line"]
            view_cast.genre = datacast_params['data']["genre"]
            view_cast.sub_genre = datacast_params['data']["subgenre"]
            view_cast.series = datacast_params['data']["series"]
        end
        r = Api::ProtoGraph::Datacast.update(payload)
        if r.has_key?("errorMessage")
            render json: {error_message: r['errorMessage']}, status: 422
        else
            updating_params = view_cast_params
            updating_params[:updated_by] = @user.id
            updating_params[:is_invalidating] = true
            view_cast.update_attributes(updating_params)
            track_activity(view_cast)
            if @account.cdn_id != ENV['AWS_CDN_ID']
                Api::ProtoGraph::CloudFront.invalidate(@account, ["/#{view_cast.datacast_identifier}/data.json","/#{view_cast.datacast_identifier}/view_cast.json"], 2)
            end
            Api::ProtoGraph::CloudFront.invalidate(nil, ["/#{view_cast.datacast_identifier}/*"], 1)
            render json: {view_cast: view_cast.as_json(methods: [:remote_urls]), redirect_path: account_folder_view_cast_url(@account, @folder, view_cast) }, status: 200
        end
    end

    private

    def datacast_params
        params.require(:datacast)
    end

    def view_cast_params
        params.require(:view_cast).permit(:datacast_identifier, :template_datum_id, :name, :template_card_id, :optionalConfigJSON, :account_id, :updated_by, :seo_blockquote, :folder_id, :updated_by, :is_invalidating)
    end

end
