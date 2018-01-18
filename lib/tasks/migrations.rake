namespace :migrations do
  task :migrate_account_to_site => :environment do
    Account.all.each do |account|
      site = Site.where({account_id: account.id, name: account.username, domain: account.domain}).first
      if not site.present?
        site = Site.create({
          account_id: account.id,
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
      else
        site.update_columns({
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
    end

    Activity.all.each do |a|
      if a.account.blank?
        a.destroy
      else
        a.update_column(:site_id, a.account.site.id)
      end
    end

    Folder.all.each do |a|
      if a.account.blank?
        a.destroy
      else
        a.update_column(:site_id, a.account.site.id)
      end
    end

    Stream.all.each do |a|
      if a.account.blank?
        a.destroy
      else
        a.update_column(:site_id, a.account.site.id)
      end
    end

  end

end