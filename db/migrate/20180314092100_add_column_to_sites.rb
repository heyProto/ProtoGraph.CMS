class AddColumnToSites < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :is_lazy_loading_activated, :boolean, default: true
  end
end
