class CreateRefCategories < ActiveRecord::Migration[5.1]
  def change

      remove_column :ref_categories, :parent_category_id
      add_column :ref_categories, :is_disabled, :boolean
      add_column :ref_categories, :created_by, :integer
      add_column :ref_categories, :updated_by, :integer

  end
end
