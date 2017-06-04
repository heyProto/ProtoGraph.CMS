class TemplateCardsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_template_card, only: [:show, :edit, :update, :destroy]

  def index
    @template_cards = @account.template_cards
  end

  def show
    @template_datum = @template_card.template_datum
  end

  def new
    @template_datum = TemplateDatum.friendly.find(params[:template_datum_id])
    @template_card = TemplateCard.new
  end

  def create
    @template_card = TemplateCard.new(template_card_params)
    @template_card.created_by = current_user.id
    @template_card.updated_by = current_user.id
    if @template_card.save
      redirect_to account_template_datum_path(@account, @template_card.template_datum), notice: t("cs")
    else
      render :new
    end
  end

  def update
    @template_card.updated_by = current_user.id
    respond_to do |format|
      if @template_card.update(template_card_params)
        format.html { redirect_to @template_card, notice: t("us") }
        format.json { render :show, status: :ok, location: @template_card }
      else
        format.html { render :edit }
        format.json { render json: @template_card.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @template_card.destroy
    redirect_to template_cards_url, notice: t("ds")
  end

  private

    def set_template_card
      @template_card = TemplateCard.friendly.find(params[:id])
    end

    def template_card_params
      params.require(:template_card).permit(:account_id, :template_datum_id, :name, :description, :slug, :version, :is_current_version, :status, :publish_count, :created_by, :updated_by)
    end
end
