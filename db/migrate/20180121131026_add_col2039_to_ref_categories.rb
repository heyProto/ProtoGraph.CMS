class AddCol2039ToRefCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :ref_categories, :name_html, :string
  end
end
