class AddColumnToVertical < ActiveRecord::Migration[5.1]
  def change
    add_column :ref_categories, :description, :text
    add_column :ref_categories, :keywords, :text
  end
end
