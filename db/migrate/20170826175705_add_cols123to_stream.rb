class AddCols123toStream < ActiveRecord::Migration[5.1]
  def change
    add_column :streams, :last_published_at, :datetime
    add_column :streams, :order_by_key, :string
    add_column :streams, :order_by_value, :string
    add_column :streams, :limit, :integer
    add_column :streams, :offset, :integer
  end
end