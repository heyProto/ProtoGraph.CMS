class AddColumnToPages < ActiveRecord::Migration[5.1]
  def change
    add_column :pages, :hide_byline, :boolean, default: false
  end
end
