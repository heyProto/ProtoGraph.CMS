class AddColumns123ToImage < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :is_cover, :boolean
  end
end
