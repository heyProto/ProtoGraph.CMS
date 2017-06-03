class TemplateDataController < ApplicationController

  before_action :authenticate_user!
  before_action :set_template_datum, only: [:show, :edit, :update, :destroy]

  def index
    @template_data = TemplateDatum.all
  end

  def show
  end

  def new
    @template_datum = TemplateDatum.new
  end

  def edit
  end

  def create
    @template_datum = TemplateDatum.new(template_datum_params)
    if @template_datum.save
      redirect_to @template_datum, notice: t("cs")
    else
      render :new
    end
  end

  def update
    respond_to do |format|
      if @template_datum.update(template_datum_params)
        format.html { redirect_to @template_datum, notice: t("us") }
        format.json { render :show, status: :ok, location: @template_datum }
      else
        format.html { render :edit }
        format.json { render json: @template_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @template_datum.destroy
    respond_to do |format|
      format.html { redirect_to template_data_url, notice: t("ds")
      format.json { head :no_content }
    end
  end

  private

    def set_template_datum
      @template_datum = TemplateDatum.friendly.find(params[:id])
    end

    def template_datum_params
      params.require(:template_datum).permit(:account_id, :name, :description, :slug, :version, :is_current_version, :status, :api_key, :publish_count, :created_by, :updated_by)
    end
end
