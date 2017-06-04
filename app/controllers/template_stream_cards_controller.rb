class TemplateStreamCardsController < ApplicationController

  before_action :authenticate_user!, :sudo_pykih_admin
  before_action :set_template_stream_card, only: [:show, :edit, :update, :destroy]

  def new
    @template_stream_card = TemplateStreamCard.new
  end

  def create
    @template_stream_card.created_by = current_user.id
    @template_stream_card.updated_by = current_user.id
    @template_stream_card = TemplateStreamCard.new(template_stream_card_params)
    if @template_stream_card.save
      redirect_to @template_stream_card, notice: t("cs")
    else
      render :new
    end
  end

  def update
    @template_stream_card.updated_by = current_user.id
    respond_to do |format|
      if @template_stream_card.update(template_stream_card_params)
        format.html { redirect_to @template_stream_card, notice: t("us") }
        format.js{ respond_with_bip(@template_stream_card) }
        format.json { render :show, status: :ok, location: @template_stream_card }
      else
        format.html { render :edit }
        format.js {respond_with_bip(@template_stream_card)}
        format.json { render json: @template_stream_card.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @template_stream_card.destroy
    redirect_to template_stream_cards_url, notice: t("ds")
  end

  private

    def set_template_stream_card
      @template_stream_card = TemplateStreamCard.find(params[:id])
    end

    def template_stream_card_params
      params.require(:template_stream_card).permit(:account_id, :template_card_id, :template_stream_id, :is_mandatory, :position, :created_by, :updated_by)
    end
end
