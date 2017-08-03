class Api::V1::ImagesController < ApiController

    skip_before_action :set_user_from_token
    skip_before_action :set_global_objects

    def create
        key = "Images/#{params[:name]}"
        encoded_file = params[:base64_image]
        content_type = params[:content_type]
        resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, key, content_type)
        render json: {s3_url: resp.first["s3_endpoint"]}, status: 200 and return
    end
end