class AddCols2ToSites < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :g_a_tracking_id, :string
  end
end
