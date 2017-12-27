class AddReverseHouseColourToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :reverse_house_colour, :string, default: "#ffffff"
  end
end
