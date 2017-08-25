class Api::V1::TagsController < ApiController

  skip_before_action :set_user_from_token
  skip_before_action :set_global_objects

  def index
    render json: {
      success: true,
      results: Tag.select(:id,:name).search(name: params[:q]).limit(10)
    }, status: 200
  end

end