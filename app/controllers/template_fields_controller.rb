class TemplateFieldsController < ApplicationController

    @@data_types = [["Short text (Maximum 255 characters)", "short_text"], ["Long text (Maximum 50k characters)", "long_text"], ["Integer", "integer"], ["Decimal", "decimal"], ["Yes/No", "boolean"], ["Temporal(Date, Time)", "temporal"]]
    @@formats = [["URL", "url"], ["Colour", "color"],["Username", "username"], ["Email", "email"], ["Password", "password"], ["IP Address Version 4", "ipv4"], ["IP Address Version 6", "ipv6"], ["Universal Unique Identifier(UUID)", "uuid"], ["Yes/No", "yes/no"], ["Y/N", "y/n"], ["True/False", "true/false"], ["1/0", "1/0"]]

    def new
        @template_datum = TemplateDatum.friendly.find(params[:template_datum_id])
        @template_field = TemplateField.new
        @data_types = @@data_types
        @formats = @@formats
    end

    def create
        @template_field = TemplateField.new(template_field_params)
        if @template_field.save
            redirect_to template_datum_path(@template_field.template_datum), notice: "Field was created successfully"
        else
            redirect_to new_template_datum_template_field_path(@template_field.template_datum), alert: "Error creating field"
        end
    end

    def edit
        @template_field = TemplateField.friendly.find(params[:id])
        @template_datum = @template_field.template_datum
        @data_types = @@data_types
        @formats = @@formats
    end

    def update
        puts "params #{params}, #{template_field_params}"
        @template_field = TemplateField.friendly.find(params[:id])
        if @template_field.update(template_field_params)
            redirect_to template_datum_path(@template_field.template_datum), notice: "Field Updated Successfully"
        else
            redirect_to edit_template_datum_template_field_path(@template_field.template_datum, @template_field), alert: "Error updating the field"
        end
    end

    def destroy
        @template_datum = TemplateDatum.friendly.find(params[:template_datum_id])
        @template_field = TemplateField.friendly.find(params[:id])
        if @template_field.destroy
            redirect_to template_datum_path(@template_datum), notice: "Field was destroyed successfully"
        else
           redirect_to template_datum_path(@template_datum), alert: "Error deleting field"
        end
    end

    private

    def template_field_params
        params.require(:template_field).permit(:template_datum_id, :key_name, :name, :data_type, :description, :help, :is_entry_title, :genre_html, :is_required, :default_value, :min, :max, :multiple_of, :ex_min, :ex_max, :format, :format_regex, :length_minimum, :length_maximum, :created_by, :updated_by, inclusion_list: [], inclusion_list_names: [])
    end
end
