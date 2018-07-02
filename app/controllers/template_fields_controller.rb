class TemplateFieldsController < ApplicationController

    def new
        @template_datum = TemplateDatum.friendly.find(params[:template_datum_id])
        @template_field = TemplateField.new
        @data_types = %w(boolean integer number string)
        @formats = %w( date time date-time uri url email ipv4 ipv6 uuid)
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
        @data_types = %w(boolean integer number string)
        @formats = %w(date time date-time uri url email ipv4 ipv6 uuid)
    end

    def update
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
        params.require(:template_field).permit(:template_datum_id, :name, :title, :data_type, :is_req, :default, :enum, :enum_names, :min, :max, :multiple_of, :ex_min, :ex_max, :format, :pattern, :min_length, :max_length)
    end
end
