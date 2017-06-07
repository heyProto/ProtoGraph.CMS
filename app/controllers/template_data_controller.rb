class TemplateDataController < ApplicationController

  before_action :authenticate_user!, :sudo_role_can_template_designer
  before_action :set_template_datum, only: [:show, :edit, :update, :destroy, :flip_public_private, :move_to_next_status]

  def index
    @template_data = @account.template_data.where(is_current_version: true)
  end

  def show
    @template_cards = @template_datum.template_cards
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
  end

  def create
    @template_datum = TemplateDatum.new(template_datum_params)
    @prev_version = TemplateDatum.friendly.find {@template_datum.previous_version_id} if @template_datum.previous_version_id.present?
    @template_datum.created_by = current_user.id
    @template_datum.updated_by = current_user.id
    if @template_datum.save
      redirect_to [@account, @template_datum], notice: t("cs")
    else
      render :new
    end
  end

  def update
    @template_datum.status = "Draft"
    @template_datum.updated_by = current_user.id
    respond_to do |format|
      if @template_datum.update(template_datum_params)
        format.js {respond_with_bip(@template_datum) }
        format.json { respond_with_bip(@template_datum) }
      else
        format.js {respond_with_bip(@template_datum)}
        format.json {respond_with_bip(@template_datum)}
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
      params.require(:template_datum).permit(:account_id, :name, :description, :slug, :status, :api_key, :publish_count, :created_by, :updated_by, :is_public, :global_slug, :elevator_pitch, :version, :is_current_version, :change_log)
    end
end
