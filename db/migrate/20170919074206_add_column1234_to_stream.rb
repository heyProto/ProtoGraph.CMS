class AddColumn1234ToStream < ActiveRecord::Migration[5.1]
  def change
    add_column :streams, :is_grouped_data_stream, :boolean, default: false
    add_column :streams, :data_group_key, :string
  end
end
