class TemplateDataController < ApplicationController

  before_action :authenticate_user!, :sudo_role_can_template_designer

  def index
    @template_data = TemplateDatum.all
  end

  def show
    @template_datum = TemplateDatum.friendly.find(params[:id])
    @template = @template_datum
    @template_cards = @template_datum.template_cards
    @siblings = @template_datum.siblings.order("version DESC")
    #@sample_json = @template_datum.sample_json
    #@json_schema = @template_datum.json_schema
  end

  private

    def template_datum_params
      params.require(:template_datum).permit(:account_id, :name, :elevator_pitch, :description, :global_slug, :is_current_version, :version_series, :previous_version_id, :version_genre, :version, :change_log, :status, :publish_count, :is_public, :created_by, :updated_by, :api_key)
    end
end
