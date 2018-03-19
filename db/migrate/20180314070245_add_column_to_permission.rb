class AddColumnToPermission < ActiveRecord::Migration[5.1]
  def change
    add_column :permissions, :stream_id, :integer
    add_column :permissions, :stream_url, :text
  end
end
