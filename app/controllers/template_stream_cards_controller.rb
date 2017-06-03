class TemplateStreamCardsController < ApplicationController
  before_action :set_template_stream_card, only: [:show, :edit, :update, :destroy]

  # GET /template_stream_cards
  # GET /template_stream_cards.json
  def index
    @template_stream_cards = TemplateStreamCard.all
  end

  # GET /template_stream_cards/1
  # GET /template_stream_cards/1.json
  def show
  end

  # GET /template_stream_cards/new
  def new
    @template_stream_card = TemplateStreamCard.new
  end

  # GET /template_stream_cards/1/edit
  def edit
  end

  # POST /template_stream_cards
  # POST /template_stream_cards.json
  def create
    @template_stream_card = TemplateStreamCard.new(template_stream_card_params)

    respond_to do |format|
      if @template_stream_card.save
        format.html { redirect_to @template_stream_card, notice: 'Template stream card was successfully created.' }
        format.json { render :show, status: :created, location: @template_stream_card }
      else
        format.html { render :new }
        format.json { render json: @template_stream_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /template_stream_cards/1
  # PATCH/PUT /template_stream_cards/1.json
  def update
    respond_to do |format|
      if @template_stream_card.update(template_stream_card_params)
        format.html { redirect_to @template_stream_card, notice: 'Template stream card was successfully updated.' }
        format.json { render :show, status: :ok, location: @template_stream_card }
      else
        format.html { render :edit }
        format.json { render json: @template_stream_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /template_stream_cards/1
  # DELETE /template_stream_cards/1.json
  def destroy
    @template_stream_card.destroy
    respond_to do |format|
      format.html { redirect_to template_stream_cards_url, notice: 'Template stream card was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template_stream_card
      @template_stream_card = TemplateStreamCard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def template_stream_card_params
      params.require(:template_stream_card).permit(:account_id, :template_card_id, :template_stream_id, :is_mandatory, :position, :created_by, :updated_by)
    end
end
