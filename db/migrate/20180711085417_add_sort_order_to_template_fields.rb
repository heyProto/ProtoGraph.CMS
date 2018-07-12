class AddSortOrderToTemplateFields < ActiveRecord::Migration[5.1]
  def change
    add_column :template_fields, :sort_order, :integer
  end
end
