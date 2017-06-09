class DatacastsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_datacast, only: [:show, :edit, :update, :destroy]

  # GET /datacasts
  # GET /datacasts.json
  def index
    #@datacasts = Datacast.all
    redirect_to new_account_datacast_path(@account)
  end

  # GET /datacasts/1
  # GET /datacasts/1.json
  def show
  end

  # GET /datacasts/new
  def new
    @datacast = Datacast.new
  end

  # GET /datacasts/1/edit
  def edit
  end

  # POST /datacasts
  # POST /datacasts.json
  def create
    @datacast = Datacast.new(datacast_params)
    respond_to do |format|
      if @datacast.save
        encoded_file = Base64.encode64(File.read(binary_file.tempfile))
        content_type = binary_file.content_type
        key = "files/#{@account.slug}/datacasts/#{@datacast.external_identifier}.json"
        resp = Api::Haiku::Utility.upload_to_cdn(encoded_file, key, content_type)
        s3_url = resp.first["s3_endpoint"]
        @datacast.update_attributes(cdn_url: s3_url)
        format.json { render json: {datacast: @datacast}, status: 200}
      else
        format.json { render json: @datacast.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /datacasts/1
  # PATCH/PUT /datacasts/1.json
  def update
    respond_to do |format|
      if @datacast.update(datacast_params)
        format.html { redirect_to @datacast, notice: 'Datacast was successfully updated.' }
        format.js{ respond_with_bip(@datacast) }
        format.json { render :show, status: :ok, location: @datacast }
      else
        format.html { render :edit }
        format.js {respond_with_bip(@datacast)}
        format.json { render json: @datacast.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /datacasts/1
  # DELETE /datacasts/1.json
  def destroy
    @datacast.destroy
    respond_to do |format|
      format.html { redirect_to datacasts_url, notice: 'Datacast was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_datacast
      @datacast = Datacast.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def datacast_params
      params.require(:datacast).permit(:slug, :template_datum_id, :external_identifier, :status, :data_timestamp, :last_updated_at, :last_data_hash, :count_publish, :count_duplicate_calls, :count_errors, :input_source, :error_messages, :json_data, :created_by)
    end
end
