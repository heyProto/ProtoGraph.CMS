class AddColumnsToAccount < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :cdn_provider, :string
    add_column :accounts, :cdn_id, :string
    add_column :accounts, :host, :text
    add_column :accounts, :cdn_endpoint, :text
    add_column :accounts, :client_token, :string
    add_column :accounts, :access_token, :string
    add_column :accounts, :client_secret, :string

    Account.all.each do |account|
      site = account.site
      account.update_columns({
        cdn_provider: site.cdn_provider,
        cdn_id: site.cdn_id,
        host: site.host,
        cdn_endpoint: site.cdn_endpoint,
        client_token: site.client_token,
        access_token: site.access_token,
        client_secret: site.client_secret
      })
    end
  end
end
