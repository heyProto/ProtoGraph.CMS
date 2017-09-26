class AddColumn123123ToArticle < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :facebook_uploading, :boolean, default: false
    add_column :articles, :twitter_uploading, :boolean, default: false
    add_column :articles, :instagram_uploading, :boolean, default: false
  end
end
