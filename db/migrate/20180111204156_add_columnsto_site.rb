class AddColumnstoSite < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :stream_id, :integer
    add_column :ref_categories, :stream_id, :integer
  end
end
