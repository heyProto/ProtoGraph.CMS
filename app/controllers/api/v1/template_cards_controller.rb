class Api::V1::TemplateCardsController < ApiController

    def index
        @template_cards = @account.template_cards.where(is_current_version: true)
        render json: {template_cards: @template_cards.as_json(only: [:account_id, :id, :slug, :global_slug,:name, :elevator_pitch, :template_datum_id], methods: [:account_slug, :icon_url])}
    end

    def show
        @template_card = @account.template_cards.where(id: params[:id]).first
        if @template_card.present?
            render json: {template_card: @template_card.as_json(only: [:account_id, :id, :slug, :global_slug,:name, :elevator_pitch,:template_datum_id], methods: [:account_slug, :files, :versions])}
        else
            return_render_card_not_found
        end
    end

    def return_render_card_not_found
        render json: {
            error_message: "Not Found"
        }, status: 404 and return
    end


end