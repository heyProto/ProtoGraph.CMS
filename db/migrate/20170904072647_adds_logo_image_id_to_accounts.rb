class AddsLogoImageIdToAccounts < ActiveRecord::Migration[5.1]
  def up
    remove_column :accounts, :logo_url if Account.columns_hash.has_key?("logo_url")
    add_column :accounts, :logo_image_id, :integer
  end

  def down
    remove_column :accounts, :logo_image_id
  end
end
