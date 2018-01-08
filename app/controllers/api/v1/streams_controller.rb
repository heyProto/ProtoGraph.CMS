class Api::V1::StreamsController < ApiController
  before_action :set_stream, only: [:update, :publish]

  def create
    @stream = Stream.new(stream_params)
    @stream.folder = @folder
    @stream.account = @account
    @stream.updator = @user
    @stream.creator = @user
    if @stream.save
      track_activity(@stream)
      render json: {stream: @stream.as_json, redirect_path: account_folder_stream_path(@account, @folder, @stream), message: "Stream created successfully"}, status: 200
    else
      render json: {errors: @stream.errors.as_json}, status: 422
    end
  end

  def update
    if @stream.update(stream_params)
      @stream.updator = @user
      track_activity(@stream)
      render json: {stream: @stream.as_json, redirect_path: account_folder_stream_path(@account, @folder, @stream), message: "Stream updated successfully"}, status: 200
    else
      render json: {errors: @stream.errors.as_json}, status: 422
    end
  end

  def publish
    unless @view_casts.count == 0
      @stream.publish
      render json: {message: "Stream published successfully"}, status: 200
    else
      render json: {error_message: "No view_casts present for the stream. At least one view_cast is required to publish stream"}, status: 422
    end
  end

  private

  def set_stream
    @folder = @account.folders.friendly.find(@folder.slug)
    if @folder.present?
      @stream =  @folder.streams.friendly.find(params[:id])
    else
      render(json: {error_message: "Stream not found"}, status: 404) and return
    end
  end

  def stream_params
    params.require(:stream).permit(:title, :description, :limit, :offset,card_list: [], folder_list: [], tag_list: [], view_cast_id_list: [], excluded_view_cast_id_list: [])
  end
end
