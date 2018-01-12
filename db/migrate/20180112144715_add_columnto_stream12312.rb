class AddColumntoStream12312 < ActiveRecord::Migration[5.1]
  def change
    add_column :streams, :order_by_type, :string
  end
end
