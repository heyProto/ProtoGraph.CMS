class AddColumnToRefCategory < ActiveRecord::Migration[5.1]
  def change
    add_column :ref_categories, :g_a_tracking_id, :string

    Site.all.each do |d|
      d.verticals.each do |v|
        v.update_column(:g_a_tracking_id, d.g_a_tracking_id)
      end
    end
  end
end
