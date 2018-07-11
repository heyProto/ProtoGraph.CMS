class TemplateCardsController < ApplicationController
  
  def index
    @template_cards = @site.template_cards.order("updated_at desc")
  end

  def show
    @template_card = TemplateCard.friendly.find(params[:id])
  end

end
