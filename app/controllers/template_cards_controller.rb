class TemplateCardsController < ApplicationController
  before_action :set_template_card, only: [:show, :edit, :update, :destroy]

  # GET /template_cards
  # GET /template_cards.json
  def index
    @template_cards = TemplateCard.all
  end

  # GET /template_cards/1
  # GET /template_cards/1.json
  def show
  end

  # GET /template_cards/new
  def new
    @template_card = TemplateCard.new
  end

  # GET /template_cards/1/edit
  def edit
  end

  # POST /template_cards
  # POST /template_cards.json
  def create
    @template_card = TemplateCard.new(template_card_params)

    respond_to do |format|
      if @template_card.save
        format.html { redirect_to @template_card, notice: 'Template card was successfully created.' }
        format.json { render :show, status: :created, location: @template_card }
      else
        format.html { render :new }
        format.json { render json: @template_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /template_cards/1
  # PATCH/PUT /template_cards/1.json
  def update
    respond_to do |format|
      if @template_card.update(template_card_params)
        format.html { redirect_to @template_card, notice: 'Template card was successfully updated.' }
        format.json { render :show, status: :ok, location: @template_card }
      else
        format.html { render :edit }
        format.json { render json: @template_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /template_cards/1
  # DELETE /template_cards/1.json
  def destroy
    @template_card.destroy
    respond_to do |format|
      format.html { redirect_to template_cards_url, notice: 'Template card was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template_card
      @template_card = TemplateCard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def template_card_params
      params.require(:template_card).permit(:account_id, :template_datum_id, :name, :description, :slug, :version, :is_current_version, :status, :publish_count, :created_by, :updated_by)
    end
end
