class AddColsToPages < ActiveRecord::Migration[5.1]
  def change
    add_column :pages, :format, :string
    add_column :pages, :importance, :string, default: "low"
  end
end
