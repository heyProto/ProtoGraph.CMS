class AddPermissibleToPermissions < ActiveRecord::Migration[5.1]
  def change
    add_column :permissions, :permissible_type, :string
    rename_column :permissions, :account_id, :permissible_id
    add_column :permission_invites, :permissible_type, :string
    add_column :permission_invites, :permissible_id, :integer


    add_column :sites, :sign_up_mode, :string

    Account.all.each do |account|
        account.site.update(sign_up_mode: account.sign_up_mode)
    end

    Permission.update_all(permissible_type: 'Account')

    remove_column :accounts, :sign_up_mode
  end
end