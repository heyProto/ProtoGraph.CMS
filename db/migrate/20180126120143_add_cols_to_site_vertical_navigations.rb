class AddColsToSiteVerticalNavigations < ActiveRecord::Migration[5.1]
  def change
    add_column :site_vertical_navigations, :sort_order, :integer
  end
end
