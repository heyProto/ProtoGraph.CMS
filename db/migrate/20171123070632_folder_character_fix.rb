class FolderCharacterFix < ActiveRecord::Migration[5.1]
  def change
    execute('ALTER TABLE folders CONVERT TO CHARACTER SET utf8;')
  end
end
