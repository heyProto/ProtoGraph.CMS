class AddColsToTemplateDatum < ActiveRecord::Migration[5.1]
  def change
    add_column :template_data, :status, :string
  end
end
