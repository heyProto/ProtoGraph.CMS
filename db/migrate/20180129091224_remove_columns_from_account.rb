class RemoveColumnsFromAccount < ActiveRecord::Migration[5.1]
  def change
    remove_column :accounts, :header_background_color, :string
    remove_column :accounts, :header_logo_id, :integer
    remove_column :accounts, :header_url, :text
    remove_column :accounts, :header_positioning, :string

    add_column :sites, :header_background_color, :string
    add_column :sites, :header_url, :text
    add_column :sites, :header_positioning, :string
  end
end
