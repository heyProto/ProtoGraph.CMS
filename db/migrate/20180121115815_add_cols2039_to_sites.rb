class AddCols2039ToSites < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :story_card_style, :string
  end
end
