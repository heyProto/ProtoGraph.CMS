class TemplateContainersController < ApplicationController
  before_action :authenticate_user!, :sudo_role_can_template_designer
  before_action :sudo_pykih_admin, except: [:index, :show]
  before_action :set_template_container, only: [:show, :edit, :update, :destroy, :flip_public_private, :move_to_next_status]

  def index
    @template_containers = @account.template_containers
  end

  def show
    @template = @template_container
    @siblings = @template_container.siblings.order("version DESC")
    @html = @template.html
    @css = @template.css
    @js = @template.js
    @config = @template.config
  end

  def flip_public_private
    redirect_to account_template_container_path(@account, @template_container), notice: @template_container.flip_public_private
  end

  def move_to_next_status
    redirect_to account_template_container_path(@account, @template_container), notice: @template_container.move_to_next_status
  end

  def new
    @template = TemplateContainer.new
    @prev_version = TemplateContainer.friendly.find(params[:id]) if params[:id].present?
    if @prev_version.present?
      @template_container.previous_version_id = params[:id]
      @template_container.deep_copy
    end
  end

  def create
    @template_container = TemplateContainer.new(template_container_params)
    @template_container.created_by = current_user.id
    @template_container.updated_by = current_user.id
    if @template_container.save
      redirect_to [@account, @template_container], notice: t("cs")
    else
      render :new
    end
  end

  def update
    @template_container.status = "Draft"
    @template_container.updated_by = current_user.id
    if @template_container.update(template_container_params)
      redirect_to account_template_container_path(@account, @template_container), notice: t("us")
    else
      @template = @template_container
      @siblings = @template_container.siblings.order("version DESC")
      @html = @template.html
      @css = @template.css
      @js = @template.js
      @config = @template.config
      render "show"
    end
  end

  def destroy
    if !@template_container.containers.first.present?
      @template_container.destroy
      redirect_to account_template_containers_path(@account), notice: t("ds")
    else
      @template_container.update_attributes(status: "Deactivated")
      redirect_to account_template_container_path(@account, @template_container), notice: t("ds")
    end
  end

  private

    def set_template_container
      @template_container = TemplateContainer.friendly.find(params[:id])
    end

    def template_container_params
      params.require(:template_container).permit(:account_id, :name, :elevator_pitch, :description, :global_slug, :is_current_version, :version_series, :previous_version_id, :version_genre, :version, :change_log, :status, :publish_count, :is_public, :created_by, :updated_by)
    end
end
