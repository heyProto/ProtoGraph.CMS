class ChangeFormatofViewCast < ActiveRecord::Migration[5.1]
  def change
    execute("ALTER TABLE view_casts CONVERT TO CHARACTER SET utf8;")
  end
end
