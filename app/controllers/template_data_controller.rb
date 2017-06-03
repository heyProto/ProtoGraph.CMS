class TemplateDataController < ApplicationController
  before_action :set_template_datum, only: [:show, :edit, :update, :destroy]

  # GET /template_data
  # GET /template_data.json
  def index
    @template_data = TemplateDatum.all
  end

  # GET /template_data/1
  # GET /template_data/1.json
  def show
  end

  # GET /template_data/new
  def new
    @template_datum = TemplateDatum.new
  end

  # GET /template_data/1/edit
  def edit
  end

  # POST /template_data
  # POST /template_data.json
  def create
    @template_datum = TemplateDatum.new(template_datum_params)

    respond_to do |format|
      if @template_datum.save
        format.html { redirect_to @template_datum, notice: 'Template datum was successfully created.' }
        format.json { render :show, status: :created, location: @template_datum }
      else
        format.html { render :new }
        format.json { render json: @template_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /template_data/1
  # PATCH/PUT /template_data/1.json
  def update
    respond_to do |format|
      if @template_datum.update(template_datum_params)
        format.html { redirect_to @template_datum, notice: 'Template datum was successfully updated.' }
        format.json { render :show, status: :ok, location: @template_datum }
      else
        format.html { render :edit }
        format.json { render json: @template_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /template_data/1
  # DELETE /template_data/1.json
  def destroy
    @template_datum.destroy
    respond_to do |format|
      format.html { redirect_to template_data_url, notice: 'Template datum was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template_datum
      @template_datum = TemplateDatum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def template_datum_params
      params.require(:template_datum).permit(:account_id, :name, :description, :slug, :version, :is_current_version, :status, :api_key, :publish_count, :created_by, :updated_by)
    end
end
