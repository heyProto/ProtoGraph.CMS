class TemplateCardsController < ApplicationController

  before_action :authenticate_user!, :sudo_pykih_admin
  before_action :set_template_card, only: [:show, :edit, :update, :destroy, :flip_public_private, :move_to_next_status]

  def index
    @template_cards = @account.template_cards
  end

  def show
    @template_datum = @template_card.template_datum
  end

  def flip_public_private
    if @template_card.is_public
      if @template_card.can_make_private?
        @template_card.update_attributes(is_public: false)
        notice = "Successfully done."
      else
        notice = "Failed. Some other account is using this card."
      end
    else
      if @template_card.can_make_public?
        @template_card.update_attributes(is_public: true)
        notice = "Successfully done."
      else
        notice = "Failed. Make sure card is published and associated data is public."
      end
    end
    redirect_to account_template_card_path(@account, @template_card), notice: notice
  end

  def new
    @template_datum = TemplateDatum.friendly.find(params[:template_datum_id])
    @template_card = TemplateCard.new
  end

  def move_to_next_status
    if @template_card.can_ready_to_publish?
      @template_card.update_attributes(status: "Ready to Publish")
      notice = "Successfully updated."
    elsif @template_card.status == "Ready to Publish"
      @template_card.update_attributes(status: "Published")
      notice = "Successfully updated."
    else
      notice = "Failed."
    end
    redirect_to account_template_card_path(@account, @template_card), notice: notice
  end

  def create
    @template_card = TemplateCard.new(template_card_params)
    @template_card.created_by = current_user.id
    @template_card.updated_by = current_user.id
    if @template_card.save
      redirect_to account_template_datum_path(@account, @template_card.template_datum), notice: t("cs")
    else
      @template_datum = @template_card.template_datum
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
    if @template_card.can_delete?
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
      params.require(:template_card).permit(:account_id, :template_datum_id, :name, :description, :slug, :status, :publish_count, :created_by, :updated_by, :is_public)
    end
end
