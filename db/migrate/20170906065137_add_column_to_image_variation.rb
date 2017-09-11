class AddColumnToImageVariation < ActiveRecord::Migration[5.1]
  def change
    add_column :image_variations, :mode, :string
    add_column :image_variations, :is_social_image, :boolean
  end
end
