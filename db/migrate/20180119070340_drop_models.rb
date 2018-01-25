class DropModels < ActiveRecord::Migration[5.1]
  def change
    drop_table  :pages
    drop_table  :page_streams
    drop_table  :site_view_casts
  end
end
