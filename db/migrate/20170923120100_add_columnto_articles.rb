class AddColumntoArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :author, :string
    add_column :articles, :article_datetime, :datetime
    add_column :articles, :view_cast_id, :integer
    add_column :articles, :default_view, :string
  end
end
