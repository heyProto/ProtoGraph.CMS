class AddColumnToSite < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :favicon_id, :integer
    add_column :sites, :logo_image_id, :integer

    remove_column :accounts, :logo_image_id
  end
end
