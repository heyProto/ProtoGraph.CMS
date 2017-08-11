class AddColsToAccount < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :cdn_provider,  :string
    add_column :accounts, :cdn_id, :string
    add_column :accounts, :invalidation_endpoint,  :text
    add_column :accounts, :cdn_endpoint,  :text
    add_column :accounts, :authorization_header_name,  :string
    add_column :accounts, :client_token,  :string
    add_column :accounts, :access_token,  :string
    add_column :accounts, :client_secret,  :string

    Account.all.each do |account|
        account.cdn_provider = "CloudFront"
        account.cdn_id = ENV['AWS_CDN_ID']
        account.invalidation_endpoint = "#{AWS_API_DATACAST_URL}/cloudfront/invalidate"
        account.authorization_header_name = "x-api-key"
        account.access_token = ENV["AWS_API_KEY"]
        account.cdn_endpoint = ENV['AWS_S3_ENDPOINT']
        account.save
    end

  end
end
