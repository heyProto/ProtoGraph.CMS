class AddCols394849384ToSites < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :tooltip_on_logo_in_masthead, :string
    add_column :ref_categories, :show_by_publisher_in_header, :boolean, default: true
  end
end
