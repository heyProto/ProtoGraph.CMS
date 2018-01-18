class AddColsToSites < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :facebook_url, :text
    add_column :sites, :twitter_url, :text
    add_column :sites, :instagram_url, :text
    add_column :sites, :youtube_url, :text
  end
end
