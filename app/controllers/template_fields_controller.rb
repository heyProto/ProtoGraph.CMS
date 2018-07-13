class TemplateFieldsController < ApplicationController

  @@data_types = [["Short text (Max 255 chars): Use for titles, names, tags, URLs, e-mail addresses", "short_text"], ["Long text (Max 50k chars): Use for descriptions, text paragraphs, articles", "long_text"], ["Integer: ID, order number, rating, quantity", "integer"], ["Decimal (34.9)", "decimal"], ["Boolean: Yes or no, 1 or 0, true or false", "boolean"], ["Temporal: Event date, opening hours", "temporal"]]

  def new
    @template_datum = TemplateDatum.friendly.find(params[:template_datum_id])
    @template_field = TemplateField.new
    @data_types = @@data_types
    @sort_order_max = @template_datum.template_fields.count+1
    puts "max=#{@sort_order_max}"
  end

  def create
    @template_field = TemplateField.new(template_field_params)
    if @template_field.save
      redirect_to site_template_datum_path(@site, @template_field.template_datum), notice: "Field was created successfully"
    else
      redirect_to new_site_template_datum_template_field_path(@site, @template_field.template_datum), alert: "Error creating field"
    end
  end

  def edit
    @template_field = TemplateField.friendly.find(params[:id])
    @template_datum = @template_field.template_datum
    @data_types = @@data_types
    @sort_order_max = @template_datum.template_fields.count
  end

  def update
    puts "params #{params}, #{template_field_params}"
    @template_field = TemplateField.friendly.find(params[:id])
    if @template_field.update(template_field_params)
      redirect_to site_template_datum_path(@site, @template_field.template_datum), notice: "Field Updated Successfully"
    else
      redirect_to edit_site_template_datum_template_field_path(@site, @template_field.template_datum, @template_field), alert: "Error updating the field"
    end
  end

  def destroy
    @template_datum = TemplateDatum.friendly.find(params[:template_datum_id])
    @template_field = TemplateField.friendly.find(params[:id])
    if @template_field.destroy
      redirect_to site_template_datum_path(@site, @template_datum), notice: "Field was destroyed successfully"
    else
      redirect_to site_template_datum_path(@site, @template_datum), alert: "Error deleting field"
    end
  end

  def move_up
    @template_datum = TemplateDatum.friendly.find(params[:template_datum_id])
    @template_field = TemplateField.friendly.find(params[:id])
    if @template_field.sort_order != 1
      @template_field.sort_order -= 1
      if @template_field.save
        redirect_to site_template_datum_path(@site, @template_datum), notice: "Field moved up successfully"
      else
        redirect_to site_template_datum_path(@site, @template_datum), alert: "Error moving up the field"
      end
    else
      redirect_to site_template_datum_path(@site, @template_datum), alert: "Field is already at the top"
    end
  end

  def move_down
    @template_datum = TemplateDatum.friendly.find(params[:template_datum_id])
    @template_field = TemplateField.friendly.find(params[:id])
    if @template_field.sort_order != @template_datum.template_fields.count
      if @template_field.sort_order == 1
        @template_field = TemplateField.where(template_datum_id: @template_field.template_datum_id).where("sort_order = ?", 2).where.not(id: @template_field.id).first
        @template_field.sort_order = 1
      elsif @template_field.sort_order == @template_datum.template_fields.count - 1
        @template_field = TemplateField.where(template_datum_id: @template_field.template_datum_id).where("sort_order = ?", @template_datum.template_fields.count).where.not(id: @template_field.id).first 
        @template_field.sort_order = @template_datum.template_fields.count - 1
      else
        @template_field.sort_order += 1
      end  
      if @template_field.save
        redirect_to site_template_datum_path(@site, @template_datum), notice: "Field moved down successfully"
      else
        redirect_to site_template_datum_path(@site, @template_datum), alert: "Error moving down the field"
      end
    else
      redirect_to site_template_datum_path(@site, @template_datum), alert: "Field is already at the bottom"
    end
  end

  private

  def template_field_params
    params.require(:template_field).permit(:template_datum_id, :key_name, :name, :data_type, :sort_order, :description, :help, :is_entry_title, :genre_html, :is_required, :default_value, :min, :max, :multiple_of, :ex_min, :ex_max, :format, :format_regex, :length_minimum, :length_maximum, :created_by, :updated_by, inclusion_list: [], inclusion_list_names: [])
  end
end