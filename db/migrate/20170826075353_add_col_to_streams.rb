class AddColToStreams < ActiveRecord::Migration[5.1]
  def change
    add_column :streams, :card_count, :integer
  end
end
