class SiteTemplateAppsController < ApplicationController
    
  before_action :authenticate_user!
  before_action :set_site_template_app, only: [:show, :edit, :update, :destroy]

  def index
    @site_template_apps = SiteTemplateApp.all
  end

  def show
  end

  def new
    @site_template_app = SiteTemplateApp.new
  end

  def edit
  end

  def create
    @site_template_app = SiteTemplateApp.new(site_template_app_params)

    respond_to do |format|
      if @site_template_app.save
        format.html { redirect_to @site_template_app, notice: 'Site template app was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @site_template_app.update(site_template_app_params)
        format.html { redirect_to @site_template_app, notice: 'Site template app was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @site_template_app.destroy
    respond_to do |format|
      format.html { redirect_to site_template_apps_url, notice: 'Site template app was successfully destroyed.' }
    end
  end

  private

    def set_site_template_app
      @site_template_app = SiteTemplateApp.find(params[:id])
    end

    def site_template_app_params
      params.require(:site_template_app).permit(:site_id, :template_app_id, :created_by, :updated_by)
    end
end
