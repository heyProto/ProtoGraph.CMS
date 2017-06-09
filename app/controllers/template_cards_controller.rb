class TemplateCardsController < ApplicationController

  before_action :authenticate_user!, :sudo_role_can_template_designer
  before_action :set_template_card, only: [:show, :edit, :update, :destroy, :flip_public_private, :move_to_next_status]

  def index
    @template_cards = @account.template_cards
  end

  def show
    @template_datum = @template_card.template_datum
  end

  def new
    @template_datum = TemplateDatum.friendly.find(params[:template_datum_id])
    @template_card = TemplateCard.new
    @prev_version = TemplateCard.friendly.find(params[:id]) if params[:id].present?
    @version_genre = params[:version_genre]
  end

  def flip_public_private
    redirect_to account_template_card_path(@account, @template_card), notice: @template_card.flip_public_private
  end

  def move_to_next_status
    redirect_to account_template_card_path(@account, @template_card), notice: @template_card.move_to_next_status
  end

  def create
    @template_card = TemplateCard.new(template_card_params)
    if @template_card.previous_version_id.present?
      @template_card.deep_copy_across_versions
    end
    @template_card.created_by = current_user.id
    @template_card.updated_by = current_user.id
    if @template_card.save
      redirect_to account_template_datum_path(@account, @template_card.template_datum), notice: t("cs")
    else
      @template_datum = @template_card.template_datum
      @prev_version = @template_card.previous
      @version_genre = @template_card.version_genre
      render :new
    end
  end

  def update
    @template_card.status = "Draft"
    @template_card.updated_by = current_user.id
    respond_to do |format|
      if @template_card.update(template_card_params)
        format.html { redirect_to @template_card, notice: t("us") }
        format.js{ respond_with_bip(@template_card) }
        format.json { render :show, status: :ok, location: @template_card }
      else
        format.html { render :edit }
        format.js {respond_with_bip(@template_card)}
        format.json { render json: @template_card.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if !@template_card.cards.first.present?
      @template_card.destroy
      redirect_to account_template_cards_path(@account), notice: t("ds")
    else
      @template_card.update_attributes(status: "Deactivated")
      redirect_to account_template_card_path(@account, @template_card), notice: t("ds")
    end
  end

  private

    def set_template_card
      @template_card = TemplateCard.friendly.find(params[:id])
    end

    def template_card_params
      params.require(:template_card).permit(:account_id, :name, :elevator_pitch, :description, :global_slug, :is_current_version, :version_series, :previous_version_id, :version_genre, :version, :change_log, :status, :publish_count, :is_public, :created_by, :updated_by, :template_datum_id)
    end
end
