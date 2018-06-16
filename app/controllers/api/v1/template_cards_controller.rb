class Api::V1::TemplateCardsController < ApiController

    def index
        if @folder.vertical.present?
          if @folder.is_for_stories
            @template_cards = @account.template_cards.where(is_current_version: true, name: ['toImageNarrative', "toCoverImage", 'toVideo: Youtube', 'toStory','toCluster', 'toQuiz', 'toTimeline', 'toVideo: JWPlayer', 'toProfile', 'toData: Rating with drill down', 'toData: IRBF Grid', 'toData: IRBF Tooltip', "toHTML", "toDataWrapper", "toBio", "toCreditPartners"]).order(:sort_order)
          else
            @template_cards = @account.template_cards.where(is_current_version: true).where.not(name: ['toImageNarrative', "toCoverImage", 'toVideo: Youtube', 'toQuiz', 'toTimeline', 'toExplain', 'toArticle', 'toVideo: JWPlayer', 'toProfile', 'toData: IRBF Grid', 'toData: IRBF Tooltip',"toHTML", "toDataWrapper", "toBio", "toCreditPartners", "toImage", "toCrossPub"])
          end
        else
          @template_cards = @account.template_cards.where(is_current_version: true, name: ['toQuiz', 'toTimeline'])
        end
        render json: {template_cards: @template_cards.as_json(only: [:account_id, :id, :slug, :global_slug,:name, :template_datum_id, :git_repo_name], methods: [:account_slug, :icon_url])}
    end

    def show
        @template_card = @account.template_cards.friendly.find(params[:id])
        if @template_card.present?
            render json: {template_card: @template_card.as_json(only: [:account_id, :id, :slug, :global_slug,:name, :elevator_pitch, :description, :template_datum_id, :git_repo_name, :is_public], methods: [:account_slug, :files, :versions])}
        else
            return_render_card_not_found
        end
    end

    def validate
        @template_card = @account.template_cards.find(params[:id])
        if @template_card.present?
            render json: {bucket_name: ENV["AWS_S3_BUCKET"], folder_name: @template_card.s3_identifier, cdn_identifier: ENV['AWS_CDN_ID']}, status: 200
            # render json: {bucket_name: "test.ss", folder_name: @template_card.s3_identifier, cdn_identifier: ENV['AWS_CDN_ID']}, status: 200
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