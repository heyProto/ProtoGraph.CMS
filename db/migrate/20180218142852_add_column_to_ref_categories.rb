class AddColumnToRefCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :ref_categories, :vertical_page_url, :text
  end
end
