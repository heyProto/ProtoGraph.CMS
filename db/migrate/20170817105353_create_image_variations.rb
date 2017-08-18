class CreateImageVariations < ActiveRecord::Migration[5.1]
  def change
    create_table :image_variations do |t|
      t.integer :image_id

      t.text    :image_url
      t.text    :image_key
      t.integer :image_width
      t.integer :image_height

      t.text    :thumbnail_url
      t.text    :thumbnail_key
      t.integer :thumbnail_width
      t.integer :thumbnail_height

      t.boolean :is_original
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
