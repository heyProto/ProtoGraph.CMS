class TemplateDataController < ApplicationController

  before_action :authenticate_user!
  before_action :set_template_datum, only: [:show, :edit, :update, :destroy]

  def index
    @template_data = @account.template_data
  end

  def show
    @template_cards = @template_datum.template_cards
  end

  def new
    @template_datum = TemplateDatum.new
  end

  def create
    @template_datum = TemplateDatum.new(template_datum_params)
    @template_datum.created_by = current_user.id
    @template_datum.updated_by = current_user.id
    if @template_datum.save
      redirect_to [@account, @template_datum], notice: t("cs")
    else
      render :new
    end
  end

  def update
    @template_datum.updated_by = current_user.id
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
    redirect_to template_data_url, notice: t("ds")
  end

  private

    def set_template_datum
      @template_datum = TemplateDatum.friendly.find(params[:id])
    end

    def template_datum_params
      params.require(:template_datum).permit(:account_id, :name, :description, :slug, :version, :is_current_version, :status, :api_key, :publish_count, :created_by, :updated_by)
    end
end
