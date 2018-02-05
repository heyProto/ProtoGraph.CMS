class RemoveCol16ColumninPage < ActiveRecord::Migration[5.1]
  def change
    remove_column :pages, :cover_image_url
    remove_column :pages, :cover_image_url_7_column
  end
end
