class AddColumnIsSmartCropEnabledToSite < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :is_smart_crop_enabled, :boolean, default: false
  end
end
