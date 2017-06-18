class Api::V1::AccountsController < ApiController

    def template_cards
        @template_cards = @account.template_cards.where(is_current_version: true)
        render json: {template_cards: @template_cards.as_json(only: [:account_id, :id, :slug, :global_slug,:name, :elevator_pitch], methods: [:account_slug, :icon_url])}
    end

end