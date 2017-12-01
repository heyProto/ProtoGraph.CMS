class CreateAudioVariations < ActiveRecord::Migration[5.1]
  def change
    create_table :audio_variations do |t|
      t.integer :account_id
      t.string :audio_id
      t.string :integer
      t.integer :start_time
      t.integer :end_time
      t.boolean :is_original
      t.integer :total_time
      t.string :subtitle_file_path
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
