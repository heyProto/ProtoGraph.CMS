class TemplatePagesController < ApplicationController

  before_action :authenticate_user!, :sudo_pykih_admin
  before_action :set_template_page, only: [:show, :edit, :update, :destroy]

  def index
    @template_pages = TemplatePage.all.page(params[:page]).per(10)
  end

  def edit
  end

  def create
    @template_app = TemplateApp.new(template_app_params)
    @template_app.created_by = current_user.id
    @template_app.created_by = current_user.id
    @template_app.save
    @template_page = @template_app.new(template_page_params)
    @template_page.created_by = current_user.id
    @template_page.updated_by = current_user.id
    if @template_page.save
      redirect_to
    else
      render "template_pages#new"
    end
  end

  def update
  end

  private

  def set_template_page
  end

  def template_page_params
    params.require(:template_page).permit(:name, :git_url, :git_branch, :git_repo_name, :status, :description)
  end

  def template_app_params
    params.require(:template_page).permit(:name, :is_public, :genre, :description, :pitch, :is_system_installed)
  end

end
