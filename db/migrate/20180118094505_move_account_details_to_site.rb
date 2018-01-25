class MoveAccountDetailsToSite < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :cdn_provider, :string
    add_column :sites, :cdn_id, :string
    add_column :sites, :host, :text
    add_column :sites, :cdn_endpoint, :text
    add_column :sites, :client_token, :string
    add_column :sites, :access_token, :string
    add_column :sites, :client_secret, :string
    add_column :sites, :facebook_url, :text
    add_column :sites, :twitter_url, :text
    add_column :sites, :instagram_url, :text
    add_column :sites, :youtube_url, :text
    add_column :sites, :g_a_tracking_id, :string
    add_column :sites, :favicon_id, :integer
    add_column :sites, :logo_image_id, :integer
    add_column :sites, :sign_up_mode, :string
    add_column :sites, :default_role, :string
    add_column :sites, :story_card_style, :string

    Account.all.each do |account|
        account.site.update_columns({
          name: account.username,
          domain: account.domain,
          cdn_provider: account.cdn_provider,
          cdn_id: account.cdn_id,
          host: account.host,
          cdn_endpoint: account.cdn_endpoint,
          client_token: account.client_token,
          access_token: account.access_token,
          client_secret: account.client_secret,
          house_colour: account.house_colour,
          reverse_house_colour: account.reverse_house_colour,
          font_colour: account.font_colour,
          reverse_font_colour: account.reverse_font_colour
        })
    end

    remove_column :accounts, :house_colour
    remove_column :accounts, :reverse_house_colour
    remove_column :accounts, :font_colour
    remove_column :accounts, :reverse_font_colour
    remove_column :accounts, :logo_image_id
    remove_column :accounts, :sign_up_mode



  end
end
