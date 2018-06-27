class RemoveColsFromSites < ActiveRecord::Migration[5.1]
  def change
    remove_column :sites, :facebook_url
    remove_column :sites, :twitter_url
    remove_column :sites, :instagram_url
    remove_column :sites, :youtube_url
  end
end
