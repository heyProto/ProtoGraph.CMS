class AddColumns123toSite < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :story_card_flip, :boolean, default: false
  end
end
