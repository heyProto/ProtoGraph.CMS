class RemoveColumnsFromAuthentications < ActiveRecord::Migration[5.1]
  def change
    remove_column :authentications, :account_id
  end
end
