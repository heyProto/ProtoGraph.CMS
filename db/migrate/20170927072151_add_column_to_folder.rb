class AddColumnToFolder < ActiveRecord::Migration[5.1]
  def change
    add_column :folders, :is_trash, :boolean, default: false

    Account.all.each do |account|
        trash_folder = account.folders.where(name: 'Recycle Bin').first
        if trash_folder.nil?
            account.folders.create(name: 'Recycle Bin', created_by: account.users.first.id, updated_by: account.users.first.id, is_system_generated: true, is_trash: true) if account.users.count > 0
        else
            trash_folder.update_column(:is_trash, true)
        end
    end
  end
end
