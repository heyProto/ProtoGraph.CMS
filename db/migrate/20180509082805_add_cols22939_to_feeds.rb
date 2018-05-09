class AddCols22939ToFeeds < ActiveRecord::Migration[5.1]
  def change
    add_column :feeds, :next_refreshed_scheduled_for, :datetime
  end
end
