class AddSiteIdToImageVariations < ActiveRecord::Migration[5.1]
  def change
    add_reference :image_variations, :site, foreign_key: true
  end
end
