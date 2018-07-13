class AddColumn123ToPage < ActiveRecord::Migration[5.1]
  def change
    add_column :pages, :html_key, :string
  end
end
