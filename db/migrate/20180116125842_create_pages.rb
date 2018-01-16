class CreatePages < ActiveRecord::Migration[5.1]
  def change
    create_table :pages do |t|
      t.integer :site_id
      t.integer :account_id
      t.string :folder_id
      t.string :headline
      t.text :meta_description
      t.datetime :publised_date
      t.boolean :is_published
      t.text :summary
      t.string :alignment
      t.boolean :isinteractive
      t.string :genre
      t.string :sub_genre
      t.string :series
      t.string :by_line
      t.integer :cover_image_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end

    create_table :page_streams do |t|
      t.integer :page_id
      t.integer :stream_id

      t.timestamps
    end
  end
end
