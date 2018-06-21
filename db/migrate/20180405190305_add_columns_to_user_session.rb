class AddColumnsToUserSession < ActiveRecord::Migration[5.1]
  def change
    add_column :user_sessions, :latitude, :string
    add_column :user_sessions, :longitude, :string
    add_column :user_sessions, :time_zone, :string
    add_column :user_sessions, :zip_code, :string
  end
end
