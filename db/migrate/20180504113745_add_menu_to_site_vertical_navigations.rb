class AddMenuToSiteVerticalNavigations < ActiveRecord::Migration[5.1]
  def change
    add_column :site_vertical_navigations, :menu, :string
  end
end
