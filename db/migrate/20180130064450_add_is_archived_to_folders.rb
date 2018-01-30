class AddIsArchivedToFolders < ActiveRecord::Migration[5.1]
  def change
    add_column :folders, :is_archived, :boolean
  end
end
