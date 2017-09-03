class AddColsToArticle < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :url, :text
    rename_column :articles, :description, :summary
  end
end
