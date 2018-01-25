class DropColumnFromPermissionInvites < ActiveRecord::Migration[5.1]
  def change
    remove_column :permission_invites, :permissible_id
    rename_column :permission_invites, :account_id, :permissible_id

    PermissionInvite.update_all(permissible_type: "Account")
  end
end
