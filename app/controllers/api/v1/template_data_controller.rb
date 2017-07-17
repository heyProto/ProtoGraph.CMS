class Api::V1::TemplateDataController < ApiController
    skip_before_action :set_user_from_token, :set_global_objects

    def create
        @template_datum, success = TemplateDatum.create_or_update(template_datum_params)
        if success
            render json: {key: "Schemas/#{@template_datum.name}/#{@template_datum.version}/",bucket: ENV["AWS_S3_BUCKET"], distribution_id: ENV["AWS_CDN_ID"]}, status: 200
        else
            render json: {error_message: "This version of #{@template_datum.name} is already published. Please publish a new version"}, status: 422
        end
    end

    private

    def template_datum_params
        params.require(:template_datum).permit(:name, :version, :change_log, :status)
    end

end