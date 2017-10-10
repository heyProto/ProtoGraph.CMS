class ChangeIsDominantDefaultTypeColourSwatches < ActiveRecord::Migration[5.1]
    def change
        change_column :colour_swatches, :is_dominant, :boolean, default: false
    end
end
