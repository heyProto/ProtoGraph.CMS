class Api::V1::TemplateDataController < ApiController

    def create
        @template_card = @account.template_cards.where(id: params[:id]).first
        if @template_card.present?
            render json: {template_card: @template_card.as_json(only: [:account_id, :id, :slug, :global_slug,:name, :elevator_pitch, :description, :template_datum_id, :git_repo_name, :is_public], methods: [:account_slug, :files, :versions])}
        else
            return_render_card_not_found
        end
    end

end