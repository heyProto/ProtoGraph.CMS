require 'json'

class TemplateDataController < ApplicationController
    def index
        @template_datums = TemplateDatum.all
    end

    def show
        @template_datum = TemplateDatum.friendly.find(params[:id])
        @template_fields = @template_datum.template_fields
        to_json_schema(@template_fields)
    end

    def to_json_schema(fields)
        @json_schema = {
            "$schema": "http://json-schema.org/draft-04/schema#",
            "properties": {
                "data": {

                }
            }
        }
        properties = {}
        reqs = []
        fields.each do |field|
            field_name = field.name
            field_title = field.title
            field_type = field.data_type

            properties[field_name] = {
                "title": field_title,
                "type": field_type
            }

            if field.is_req.present? and field.is_req == true
                reqs << field_name
            end

            if field.default.present?
                properties[field_name]["default"] = field.default
            end

            if field.enum.present?
                properties[field_name]["enum"] = field.enum
            end

            if field.enum_names.present?
                properties[field_name]["enum_names"] = field.enum_names
            end

            if ["number", "integer"].include?(field_type)
                if field.min.present?
                    properties[field_name][:minimum] = field.min
                end
                if field.max.present?
                    properties[field_name][:maximum] = field.max
                end
                if field.multiple_of.present?
                    properties[field_name][:multipleOf] = field.multiple_of
                end
                if field.ex_min.present?
                    properties[field_name][:exclusiveMinimum] = field.ex_min
                end
                if field.ex_max.present?
                    properties[field_name][:exclusiveMaximum] = field.ex_max
                end
            elsif field_type == "string"
                if field.format.present?
                    properties[field_name][:format] = field.format
                end
                if field.pattern.present?
                    properties[field_name][:pattern] = field.pattern
                end
                if field.min_length
                    properties[field_name][:minLength] = field.min_length
                end
                if field.max_length
                    properties[field_name][:maxLength] = field.max_length
                end
            end
        end
        @json_schema[:properties][:required] = reqs if reqs.length > 0
        @json_schema[:properties][:data][:properties] = properties
        puts @json_schema
        @json_schema = JSON.pretty_generate(@json_schema)
    end
end
