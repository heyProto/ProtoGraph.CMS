class TemplateAppsController < ApplicationController
  before_action :set_template_app, only: [:show, :edit, :update, :destroy]

  # GET /template_apps
  # GET /template_apps.json
  def index
    @template_apps = TemplateApp.all
  end

  # GET /template_apps/1
  # GET /template_apps/1.json
  def show
  end

  # GET /template_apps/new
  def new
    @template_app = TemplateApp.new
  end

  # GET /template_apps/1/edit
  def edit
  end

  # POST /template_apps
  # POST /template_apps.json
  def create
    @template_app = TemplateApp.new(template_app_params)

    respond_to do |format|
      if @template_app.save
        format.html { redirect_to @template_app, notice: 'Template app was successfully created.' }
        format.json { render :show, status: :created, location: @template_app }
      else
        format.html { render :new }
        format.json { render json: @template_app.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /template_apps/1
  # PATCH/PUT /template_apps/1.json
  def update
    respond_to do |format|
      if @template_app.update(template_app_params)
        format.html { redirect_to @template_app, notice: 'Template app was successfully updated.' }
        format.json { render :show, status: :ok, location: @template_app }
      else
        format.html { render :edit }
        format.json { render json: @template_app.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /template_apps/1
  # DELETE /template_apps/1.json
  def destroy
    @template_app.destroy
    respond_to do |format|
      format.html { redirect_to template_apps_url, notice: 'Template app was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template_app
      @template_app = TemplateApp.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def template_app_params
      params.require(:template_app).permit(:name, :genre, :pitch, :description, :is_public, :installs, :views, :created_by, :updated_by, :change_log)
    end
end
