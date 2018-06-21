class AddColumnToSite < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :comscore_code, :text
  end
end
