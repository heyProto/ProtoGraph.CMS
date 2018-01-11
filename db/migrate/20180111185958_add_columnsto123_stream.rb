class AddColumnsto123Stream < ActiveRecord::Migration[5.1]
  def change
    add_column :streams, :is_automated_stream, :boolean, default: false
    add_column :streams, :col_name, :string
    add_column :streams, :col_id, :integer
  end
end
