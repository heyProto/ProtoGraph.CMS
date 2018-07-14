require 'json'

class TemplateDataController < ApplicationController
  
  def index
    @template_datums = @site.template_data.order("updated_at desc")
  end

  def show
    @template_datum = TemplateDatum.friendly.find(params[:id])
    @template_fields = @template_datum.template_fields.order("sort_order")
    @json_schema = JSON.pretty_generate(@template_datum.get_schema_json)
  end
end
