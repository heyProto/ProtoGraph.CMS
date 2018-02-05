class AddColsIsStoriesForFolders < ActiveRecord::Migration[5.1]
  def change
    add_column :folders, :is_for_stories, :boolean
  end
end
