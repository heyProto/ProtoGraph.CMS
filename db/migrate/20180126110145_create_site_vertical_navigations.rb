class CreateSiteVerticalNavigations < ActiveRecord::Migration[5.1]
  def change
    create_table :site_vertical_navigations do |t|
      t.integer :site_id
      t.integer :ref_category_vertical_id
      t.string :name
      t.text :url
      t.boolean :launch_in_new_window
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
