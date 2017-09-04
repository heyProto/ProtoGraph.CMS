class DropImageUrlFromImageVariation < ActiveRecord::Migration[5.1]
  def change
    remove_column :image_variations, :image_url
  end
end
