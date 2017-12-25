class AddNameToColourSwatches < ActiveRecord::Migration[5.1]
  def change
    add_column :colour_swatches, :name, :string
  end
end
