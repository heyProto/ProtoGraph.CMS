class AddFontColourAndReverseFontColourToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :font_colour, :string, default: "#ffffff"
    add_column :accounts, :reverse_font_colour, :string, default: "#ffffff"
  end
end
