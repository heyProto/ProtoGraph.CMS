class RemoveColumnsFromAccount < ActiveRecord::Migration[5.1]
  def change
    remove_column :accounts, :cdn_provider
    remove_column :accounts, :cdn_id
    remove_column :accounts, :host
    remove_column :accounts, :cdn_endpoint
    remove_column :accounts, :client_token
    remove_column :accounts, :access_token
    remove_column :accounts, :client_secret

    remove_column :accounts, :house_colour
    remove_column :accounts, :reverse_house_colour
    remove_column :accounts, :font_colour
    remove_column :accounts, :reverse_font_colour
  end
end
