class AddShowBySiteNameToSites < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :show_by_site_name, :boolean
  end
end
