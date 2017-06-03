class CreateDatacasts < ActiveRecord::Migration[5.1]
  def change
    create_table :datacasts do |t|
      t.string :slug
      t.integer :template_datum_id
      t.string :external_identifier
      t.string :status
      t.datetime :data_timestamp
      t.datetime :last_updated_at
      t.string :last_data_hash
      t.integer :count_publish
      t.integer :count_duplicate_calls
      t.integer :count_errors
      t.string :input_source
      t.text :error_messages
      t.text :data
      t.integer :created_by

      t.timestamps
    end
    add_index :datacasts, :slug, unique: true
    add_index :datacasts, :external_identifier

    create_table :datacast_accounts do |t|
      t.integer :datacast_id
      t.integer :account_id
      t.boolean :is_active

      t.timestamps
    end
  end
end
