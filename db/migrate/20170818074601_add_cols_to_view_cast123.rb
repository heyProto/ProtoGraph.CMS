class AddColsToViewCast123 < ActiveRecord::Migration[5.1]
  def change
    add_column :view_casts, :folder_id, :integer


    Account.all.each do |account|
        folder = Folder.create({
            account_id: account.id,
            name: "Sample Project",
            created_by: account.users.first.id,
            updated_by: account.users.first.id
        })

        account.view_casts.update_all(folder_id: folder.id)
    end
  end
end
