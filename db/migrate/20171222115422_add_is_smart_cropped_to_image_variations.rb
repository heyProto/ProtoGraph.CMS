class AddIsSmartCroppedToImageVariations < ActiveRecord::Migration[5.1]
  def change
    add_column :image_variations, :is_smart_cropped, :boolean, default: false
  end
end
