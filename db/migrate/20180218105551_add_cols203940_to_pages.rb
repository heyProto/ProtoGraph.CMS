class AddCols203940ToPages < ActiveRecord::Migration[5.1]
  def change
    add_column :pages, :content, :text
  end
end
