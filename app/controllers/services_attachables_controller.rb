class ServicesAttachablesController < ApplicationController
  before_action :set_services_attachable, only: [:show, :edit, :update, :destroy]

  # GET /services_attachables
  # GET /services_attachables.json
  def index
    @services_attachables = ServicesAttachable.all
  end

  # GET /services_attachables/1
  # GET /services_attachables/1.json
  def show
  end

  # GET /services_attachables/new
  def new
    @services_attachable = ServicesAttachable.new
  end

  # GET /services_attachables/1/edit
  def edit
  end

  # POST /services_attachables
  # POST /services_attachables.json
  def create
    @services_attachable = ServicesAttachable.new(services_attachable_params)

    respond_to do |format|
      if @services_attachable.save
        format.html { redirect_to @services_attachable, notice: 'Services attachable was successfully created.' }
        format.json { render :show, status: :created, location: @services_attachable }
      else
        format.html { render :new }
        format.json { render json: @services_attachable.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /services_attachables/1
  # PATCH/PUT /services_attachables/1.json
  def update
    respond_to do |format|
      if @services_attachable.update(services_attachable_params)
        format.html { redirect_to @services_attachable, notice: 'Services attachable was successfully updated.' }
        format.json { render :show, status: :ok, location: @services_attachable }
      else
        format.html { render :edit }
        format.json { render json: @services_attachable.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /services_attachables/1
  # DELETE /services_attachables/1.json
  def destroy
    @services_attachable.destroy
    respond_to do |format|
      format.html { redirect_to services_attachables_url, notice: 'Services attachable was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_services_attachable
      @services_attachable = ServicesAttachable.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def services_attachable_params
      params.require(:services_attachable).permit(:account_id, :attachable_id, :attachable_type, :genre, :file_url, :original_file_name, :file_type, :s3_bucket, :created_by, :updated_by)
    end
end
