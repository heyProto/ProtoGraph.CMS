class TemplateDataController < ApplicationController

  require 'version'

  before_action :authenticate_user!, :sudo_role_can_template_designer
  before_action :set_template_datum, only: [:show, :edit, :update, :destroy, :flip_public_private, :move_to_next_status]

  def index
    @template_data = @account.template_data.where(is_current_version: true)
  end

  def show
    @template_cards = @template_datum.template_cards
    @current_version = @template_datum.current_version
    @siblings = @template_datum.siblings.order("version DESC")
    @sample_json = @template_datum.sample_json
    @json_schema = @template_datum.json_schema
  end

  def flip_public_private
    redirect_to account_template_datum_path(@account, @template_datum), notice: @template_datum.flip_public_private
  end

  def move_to_next_status
    redirect_to account_template_datum_path(@account, @template_datum), notice: @template_datum.move_to_next_status
  end

  def new
    @template_datum = TemplateDatum.new
    @prev_version = TemplateDatum.friendly.find(params[:id]) if params[:id].present?
    @version_genre = params[:version_genre]
  end

  def create
    @template_datum = TemplateDatum.new(template_datum_params)
    if @template_datum.previous_version_id.present?
      @template_datum.deep_copy_across_versions
    end
    @template_datum.created_by = current_user.id
    @template_datum.updated_by = current_user.id
    if @template_datum.save
      redirect_to [@account, @template_datum], notice: t("cs")
    else
      @prev_version = @template_datum.previous
      @version_genre = @template_datum.version_genre
      render :new
    end
  end

  def update
    @template_datum.status = "Draft"
    @template_datum.updated_by = current_user.id
    respond_to do |format|
      if @template_datum.update(template_datum_params)
        format.html { redirect_to [@account, @template_datum], notice: t("us") }
      else
        @template_cards = @template_datum.template_cards
        @current_version = @template_datum.current_version
        @siblings = @template_datum.siblings.order("version DESC")
        @sample_json = @template_datum.sample_json
        @json_schema = @template_datum.json_schema
        format.html { render :show }
      end
    end
  end

  def destroy
    if !@template_datum.datacasts.first.present?
      @template_datum.destroy
      redirect_to account_template_data_path(@account), notice: t("ds")
    else
      @template_datum.update_attributes(status: "Deactivated")
      redirect_to account_template_datum_path(@account, @template_datum), notice: t("ds")
    end
  end

  private

    def set_template_datum
      @template_datum = TemplateDatum.friendly.find(params[:id])
    end

    def template_datum_params
      params.require(:template_datum).permit(:account_id, :name, :elevator_pitch, :description, :global_slug, :is_current_version, :version_series, :previous_version_id, :version_genre, :version, :change_log, :status, :publish_count, :is_public, :created_by, :updated_by, :api_key)
    end
end
