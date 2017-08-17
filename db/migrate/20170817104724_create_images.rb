class CreateImages < ActiveRecord::Migration[5.1]
  def up
    create_table :images do |t|
      t.integer :account_id
      t.string  :name
      t.text    :description
      t.string  :s3_identifer
      t.text    :thumbnail_url
      t.integer :thumbnail_width
      t.integer :thumbnail_height
      t.string  :image
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end

  def down
    drop_table :images
  end
end
