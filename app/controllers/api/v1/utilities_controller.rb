class Api::V1::UtilitiesController < ApiController
  skip_before_action :set_user_from_token, :set_global_objects
  def iframely
    if params['url'].present?
      url = "http://13.126.206.16:8000/iframely"
      begin
        response = RestClient::Request.execute(
          method: "get",
          url: url,
          headers: {
            params: {
              url: utility_params['url']
            }
          }
        )

       render json: JSON.parse(response)
      rescue Exception => e
        render json: {success: false, message: e.to_s}, status: 400
      end
    else
      render json: {success: false, message: t('url.required')}, status: 400
    end
  end

  def oembed
    url = "http://13.126.206.16:8000/oembed"
    if params['url'].present?
      begin
        response = RestClient::Request.execute(
          method: "get",
          url: url,
          headers: {
            params: {
              url: utility_params['url'],
            }
          }
        )
        render json: JSON.parse(response)
      rescue  Exception => e
        render json: {success: false, message: e.to_s}, status: 400
      end
    else
      render json: {success: false, message: t('url.required')}, status: 400
    end
  end

  private

  def utility_params
    params.permit(:url)
  end
end
