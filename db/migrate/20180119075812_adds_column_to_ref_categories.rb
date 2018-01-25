class AddsColumnToRefCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :ref_categories, :count, :integer, default: 0
    rename_column :ref_categories, :category, :genre
  end
end
