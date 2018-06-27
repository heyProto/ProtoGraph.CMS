class AddSeoNameToSite < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :seo_name, :string

    Site.update_all("seo_name = name")
  end
end
