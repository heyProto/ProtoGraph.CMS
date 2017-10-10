class CreateColourSwatches < ActiveRecord::Migration[5.1]
  def change
    create_table :colour_swatches do |t|
      t.integer :red
      t.integer :green
      t.integer :blue
      t.integer :image_id
      t.boolean :is_dominant

      t.timestamps
    end
  end
end
