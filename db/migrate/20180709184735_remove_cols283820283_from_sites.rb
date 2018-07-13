class RemoveCols283820283FromSites < ActiveRecord::Migration[5.1]
  def change
    remove_column :sites, :email_domain
    remove_column :sites, :sign_up_mode
    remove_column :sites, :default_role
  end
end
