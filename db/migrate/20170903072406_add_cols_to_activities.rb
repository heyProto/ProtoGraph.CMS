class AddColsToActivities < ActiveRecord::Migration[5.1]
  def change
    add_column :activities, :folder_id, :integer
    add_column :activities, :account_id, :integer
  end
end
