require 'json'

class TemplateDataController < ApplicationController
  def index
    @template_datums = TemplateDatum.all.order("updated_at desc")
  end

  def show
    @template_datum = TemplateDatum.friendly.find(params[:id])
    @template_fields = @template_datum.template_fields
    # to_json_schema(@template_fields)
    @json_schema = JSON.pretty_generate(@template_datum.get_schema_json)
  end

  # def to_json_schema(fields)
  #   @json_schema = {
  #     "$schema": "http://json-schema.org/draft-04/schema#",
  #     "properties": {
  #       "data": {
  #
  #       }
  #     }
  #   }
  #   properties = {}
  #   reqs = []
  #   fields.each do |field|
  #     field_key = field.key_name
  #     field_name = field.name
  #     field_type = %w(short_text long_text).include?(field.data_type) ? "string" : field.data_type
  #
  #     properties[field_key] = {
  #       "title": field_name,
  #       "type": field_type
  #     }
  #
  #     if field.is_required.present? and field.is_required == true
  #       reqs << field_key
  #     end
  #
  #     if field.default_value.present?
  #       properties[field_key]["default"] = field.default_value
  #     end
  #
  #     if field.inclusion_list.present?
  #       properties[field_key]["enum"] = field.inclusion_list
  #     end
  #
  #     if field.inclusion_list_names.present?
  #       properties[field_key]["enum_names"] = field.inclusion_list_names
  #     end
  #
  #     if ["decimal", "integer"].include?(field_type)
  #       if field.min.present?
  #         properties[field_key][:minimum] = field.min
  #       end
  #       if field.max.present?
  #         properties[field_key][:maximum] = field.max
  #       end
  #       if field.multiple_of.present?
  #         properties[field_key][:multipleOf] = field.multiple_of
  #       end
  #       if field.ex_min.present?
  #         properties[field_key][:exclusiveMinimum] = field.ex_min
  #       end
  #       if field.ex_max.present?
  #         properties[field_key][:exclusiveMaximum] = field.ex_max
  #       end
  #     elsif %w(short_text long_text).include?(field_type)
  #       if field.format.present?
  #         properties[field_key][:format] = field.format
  #       end
  #       if field.pattern.present?
  #         properties[field_key][:pattern] = field.format_regex
  #       end
  #       if field.min_length
  #         properties[field_key][:minLength] = field.length_minimum
  #       end
  #       if field.max_length
  #         properties[field_key][:maxLength] = field.length_maximum
  #       end
  #     end
  #   end
  #   @json_schema[:properties][:required] = reqs if reqs.length > 0
  #   @json_schema[:properties][:data][:properties] = properties
  #   puts @json_schema
  #   @json_schema = JSON.pretty_generate(@json_schema)
  # end
end
