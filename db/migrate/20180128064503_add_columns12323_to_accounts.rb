class AddColumns12323ToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :header_background_color, :string
    add_column :accounts, :header_logo_id, :integer
    add_column :accounts, :header_url, :text
    add_column :accounts, :header_positioning, :string
  end
end
