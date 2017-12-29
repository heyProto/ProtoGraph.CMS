class CreateAudios < ActiveRecord::Migration[5.1]
  def change
    create_table :audios do |t|
      t.integer :account_id
      t.string :name
      t.string :audio
      t.text :description
      t.string :s3_identifier
      t.integer :total_time
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :audios, :s3_identifier, unique: true
    add_index :audios, :account_id
    add_index :audios, :id, unique: true
  end
end
