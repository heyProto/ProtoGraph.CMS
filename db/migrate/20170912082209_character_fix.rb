class CharacterFix < ActiveRecord::Migration[5.1]
  def change
    execute('ALTER TABLE articles CONVERT TO CHARACTER SET utf8;')
    execute('ALTER TABLE images CONVERT TO CHARACTER SET utf8;')
  end
end
