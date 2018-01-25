class AddColumnsToImage < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :is_favicon, :boolean, default: false
  end
end
