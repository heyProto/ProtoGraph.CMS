class AddColumnstoStream < ActiveRecord::Migration[5.1]
  def change
    add_column :streams, :include_data, :boolean, default: false
  end
end
