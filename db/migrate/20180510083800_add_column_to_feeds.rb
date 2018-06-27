class AddColumnToFeeds < ActiveRecord::Migration[5.1]
  def change
    add_column :feeds, :custom_errors, :text
  end
end
