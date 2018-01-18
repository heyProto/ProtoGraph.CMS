class MoveAccountDetailsToSite < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :cdn_provider, :string
    add_column :sites, :cdn_id, :string
    add_column :sites, :host, :text
    add_column :sites, :cdn_endpoint, :text
    add_column :sites, :client_token, :string
    add_column :sites, :access_token, :string
    add_column :sites, :client_secret, :string

    require 'rake'
    puts ">>>>>>>>>>>>> Migrating Data"
    Rake::Task['migrations:migrate_account_to_site'].invoke
    puts ">>>>>>>>>>>>> Data Migrated"
  end
end
