class RenameColumninAccounts < ActiveRecord::Migration[5.1]
  def change
    remove_column :accounts, :authorization_header_name
    rename_column :accounts, :invalidation_endpoint, :host


    Account.all.each do |account|
        account.update_columns(client_token: ENV['AWS_ACCESS_KEY_ID'], client_secret: ENV['AWS_SECRET_ACCESS_KEY'], cdn_id: ENV['AWS_CDN_ID'])
    end
  end
end
