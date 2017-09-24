class AddColumnsToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :house_colour, :string
  end
end
