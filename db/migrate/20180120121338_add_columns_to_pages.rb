class AddColumnsToPages < ActiveRecord::Migration[5.1]
  def change
    add_column :pages, :datacast_identifier, :string
  end
end
