class AddColumnsToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :house_colour, :string, default: "#55a8fd"
  end
end
