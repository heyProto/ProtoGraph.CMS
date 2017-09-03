class AddColumn123toArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :slug, :string
  end
end
