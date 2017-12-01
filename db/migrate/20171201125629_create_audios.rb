class CreateAudios < ActiveRecord::Migration[5.1]
  def change
    create_table :audios do |t|
      t.integer :account_id
      t.string :name
      t.text :description
      t.string :s3_identifier
      t.integer :total_time
      t.string :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :audios, :s3_identifier, unique: true
  end
end
