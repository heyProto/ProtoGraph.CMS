class TemplateStreamsController < ApplicationController
  before_action :set_template_stream, only: [:show, :edit, :update, :destroy]

  # GET /template_streams
  # GET /template_streams.json
  def index
    @template_streams = TemplateStream.all
  end

  # GET /template_streams/1
  # GET /template_streams/1.json
  def show
  end

  # GET /template_streams/new
  def new
    @template_stream = TemplateStream.new
  end

  # GET /template_streams/1/edit
  def edit
  end

  # POST /template_streams
  # POST /template_streams.json
  def create
    @template_stream = TemplateStream.new(template_stream_params)

    respond_to do |format|
      if @template_stream.save
        format.html { redirect_to @template_stream, notice: 'Template stream was successfully created.' }
        format.json { render :show, status: :created, location: @template_stream }
      else
        format.html { render :new }
        format.json { render json: @template_stream.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /template_streams/1
  # PATCH/PUT /template_streams/1.json
  def update
    respond_to do |format|
      if @template_stream.update(template_stream_params)
        format.html { redirect_to @template_stream, notice: 'Template stream was successfully updated.' }
        format.json { render :show, status: :ok, location: @template_stream }
      else
        format.html { render :edit }
        format.json { render json: @template_stream.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /template_streams/1
  # DELETE /template_streams/1.json
  def destroy
    @template_stream.destroy
    respond_to do |format|
      format.html { redirect_to template_streams_url, notice: 'Template stream was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template_stream
      @template_stream = TemplateStream.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def template_stream_params
      params.require(:template_stream).permit(:account_id, :name, :description, :slug, :version, :is_current_version, :status, :publish_count, :created_by, :updated_by)
    end
end
