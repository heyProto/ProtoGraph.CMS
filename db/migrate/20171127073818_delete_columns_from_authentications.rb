class DeleteColumnsFromAuthentications < ActiveRecord::Migration[5.1]
  def change
    remove_column :authentications, :created_by
    remove_column :authentications, :updated_by
    add_column :authentications, :user_id, :integer
    add_index :authentications, :user_id
  end
end
