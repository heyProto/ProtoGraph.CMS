class Api::V1::DatacastsController < ApiController

    def create
        payload = {}
        view_cast = @folder.view_casts.new(view_cast_params)
        view_cast.site_id = @site.id
        view_cast.created_by = @user.id
        view_cast.updated_by = @user.id
        view_cast.collaborator_lists = ["#{current_user.id}"] if ["contributor", "writer"].include?(@permission_role.slug)
        view_cast.data_json = datacast_params
        if view_cast.template_card.name == 'toStory'
            view_cast.by_line = datacast_params['data']["by_line"]
            view_cast.intersection = @site.ref_categories.where(genre: "intersection").where(name: datacast_params['data']["genre"]).first
            view_cast.sub_intersection = @site.ref_categories.where(genre: "sub intersection").where(name: datacast_params['data']["subgenre"]).first
            view_cast.format = datacast_params['data']["format"] if datacast_params['data']["format"].present?
            view_cast.importance = datacast_params['data']["importance"] if datacast_params['data']["importance"].present?
            view_cast.external_identifier = datacast_params['data']["external_identifier"] if datacast_params['data']["external_identifier"].present?
        end
        if ['toStory', 'toCluster'].include?(view_cast.template_card.name)
            view_cast.series = @folder.vertical
            view_cast.published_at = Date.parse(datacast_params['data'][TemplateCard::PUBLISHED_COLUMN_MAP[view_cast.template_card.name]])
            datacast_params['data']['series'] = @folder.vertical.name
        end
        payload["payload"] = datacast_params.to_json
        payload["source"]  = params[:source] || "form"
        if view_cast.save
            payload["api_slug"] = view_cast.datacast_identifier
            payload["schema_url"] = view_cast.template_datum.schema_json
            payload["bucket_name"] = @site.cdn_bucket
            r = Api::ProtoGraph::Datacast.create(payload)
            if r.has_key?("errorMessage")
                view_cast.destroy
                render json: {error_message: r['errorMessage']}, status: 422
            else
                render json: {view_cast: view_cast.as_json(methods: [:remote_urls]), redirect_path: site_folder_view_cast_url(@site, @folder, view_cast) }, status: 200
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
            view_cast.intersection = @site.ref_categories.where(genre: "intersection").where(name: datacast_params['data']["genre"]).first
            view_cast.sub_intersection = @site.ref_categories.where(genre: "sub intersection").where(name: datacast_params['data']["subgenre"]).first
            view_cast.external_identifier = datacast_params['data']["external_identifier"] if datacast_params['data']["external_identifier"].present?
            datacast_params['data']['series'] = @folder.vertical.name
            view_cast.format = datacast_params['data']["format"] if datacast_params['data']["format"].present?
            view_cast.importance = datacast_params['data']["importance"] if datacast_params['data']["importance"].present?
        end
        if ['toStory', 'toCluster'].include?(view_cast.template_card.name)
            view_cast.series = @folder.vertical
            view_cast.published_at = Date.parse(datacast_params['data'][TemplateCard::PUBLISHED_COLUMN_MAP[view_cast.template_card.name]])
        end
        payload["bucket_name"] = @site.cdn_bucket
        r = Api::ProtoGraph::Datacast.update(payload)
        if r.has_key?("errorMessage")
            render json: {error_message: r['errorMessage']}, status: 422
        else
            updating_params = view_cast_params
            updating_params[:updated_by] = @user.id
            updating_params[:is_invalidating] = true
            updating_params[:data_json] = JSON.parse(datacast_params.to_json)
            view_cast.update_attributes(updating_params)
            Api::ProtoGraph::CloudFront.invalidate(@site, ["/#{view_cast.datacast_identifier}/*"], 1)
            render json: {view_cast: view_cast.as_json(methods: [:remote_urls]), redirect_path: site_folder_view_cast_url(@site, @folder, view_cast) }, status: 200
        end
    end

    private

    def datacast_params
        params.require(:datacast)
    end

    def view_cast_params
        params.require(:view_cast).permit(:datacast_identifier, :template_datum_id, :name, :template_card_id, :optionalconfigjson, :site_id, :updated_by, :seo_blockquote, :folder_id, :updated_by, :is_invalidating, :data_json)
    end

end
