class CreateStreams < ActiveRecord::Migration[5.1]
  def change
    create_table :streams do |t|
      t.string :title
      t.string :slug
      t.text :description
      t.integer :folder_id
      t.integer :account_id
      t.string :datacast_identifier
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end

    add_index :streams, [:title]
    add_index :streams, [:description], length: 10

    create_table :stream_entities do |t|
      t.integer :stream_id
      t.string :entity_type
      t.string :entity_value
      t.boolean :is_excluded
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
