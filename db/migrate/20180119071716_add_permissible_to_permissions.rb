class AddPermissibleToPermissions < ActiveRecord::Migration[5.1]
  def change
    add_column :permissions, :permissible_type, :string
    rename_column :permissions, :account_id, :permissible_id
    add_column :permission_invites, :permissible_type, :string
    add_column :permission_invites, :permissible_id, :integer

    Permission.update_all(permissible_type: 'Account')

  end
end