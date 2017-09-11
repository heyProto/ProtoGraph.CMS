class AddColumnsToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :instagram_image_variation_id, :integer
  end
end
