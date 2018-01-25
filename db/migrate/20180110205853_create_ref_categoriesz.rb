class CreateRefCategoriesz < ActiveRecord::Migration[5.1]
  def change
    create_table :ref_categories do |t|
      t.integer :site_id
      t.string :category
      t.string :name
      t.integer :parent_category_id
      t.text :stream_url

      t.timestamps
    end

    create_table :ref_tags do |t|
      t.integer :site_id
      t.string :name

      t.timestamps
    end

    create_table :site_view_casts do |t|
      t.integer :site_id
      t.integer :view_cast_id

      t.timestamps
    end

  end
end
