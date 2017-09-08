class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.integer :account_id
      t.integer :folder_id
      t.integer :cover_image_id
      t.string :title
      t.text :description
      t.text :content
      t.string :genre
      t.text :og_image_variation_id
      t.integer :og_image_width
      t.integer :og_image_height
      t.text :twitter_image_variation_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
