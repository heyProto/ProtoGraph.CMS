class AddIsHiddenToPermissions < ActiveRecord::Migration[5.1]
  def change
    add_column :permissions, :is_hidden, :boolean, default: false
  end
end
