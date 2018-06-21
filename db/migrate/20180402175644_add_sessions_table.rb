class AddSessionsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end

    create_table :user_sessions do |t|
      t.string :session_id
      t.integer :user_id
      t.string :ip
      t.string :user_agent
      t.string :location_city
      t.string :location_state
      t.string :location_country

      t.timestamps
    end
  end
end
