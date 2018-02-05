class AddColumnsToPage < ActiveRecord::Migration[5.1]
  def change
    add_column :pages, :cover_image_id, :integer
    add_column :pages, :cover_image_id_7_column, :integer
  end
end
