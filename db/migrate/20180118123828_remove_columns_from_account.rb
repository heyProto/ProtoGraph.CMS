class RemoveColumnsFromAccount < ActiveRecord::Migration[5.1]
  def change
    remove_column :accounts, :house_colour
    remove_column :accounts, :reverse_house_colour
    remove_column :accounts, :font_colour
    remove_column :accounts, :reverse_font_colour
  end
end
