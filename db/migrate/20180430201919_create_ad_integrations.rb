class CreateAdIntegrations < ActiveRecord::Migration[5.1]
  def change
    create_table :ad_integrations do |t|
      t.integer :account_id
      t.integer :site_id
      t.integer :stream_id
      t.integer :page_id
      t.integer :sort_order
      t.string :div_id
      t.integer :height
      t.integer :width
      t.text :slot_text
      t.integer :page_stream_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end

    add_column :sites, :enable_ads, :boolean, default: false
  end
end