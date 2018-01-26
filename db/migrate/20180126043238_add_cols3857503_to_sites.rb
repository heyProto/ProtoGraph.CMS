class AddCols3857503ToSites < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :email_domain, :string
    Rake::Task['migrate_domains:add'].invoke
    remove_column :accounts, :domain
  end
end
