class CreatePageStreams < ActiveRecord::Migration[5.1]
  def change
    create_table :page_streams do |t|
      t.integer :page_id
      t.integer :stream_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
