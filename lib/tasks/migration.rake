namespace :migration do
    task temp: :environment do
      RefCategory.where(genre: "series").update_all(show_by_publisher_in_header: true)
      Site.all.each do |s|
        s.ref_categories.where(genre: "series").each do |r|
          if s.facebook_url.present?
            SiteVerticalNavigation.create(site_id: s.id, ref_category_vertical_id: r.id, name: "Facebook", url: s.facebook_url, launch_in_new_window: true, account_id: s.account_id)
          end
          if s.twitter_url.present?
            SiteVerticalNavigation.create(site_id: s.id, ref_category_vertical_id: r.id, name: "Twitter", url: s.twitter_url, launch_in_new_window: true, account_id: s.account_id)
          end
          if s.instagram_url.present?
            SiteVerticalNavigation.create(site_id: s.id, ref_category_vertical_id: r.id, name: "Instagram", url: s.instagram_url, launch_in_new_window: true, account_id: s.account_id)
          end
          if s.youtube_url.present?
            SiteVerticalNavigation.create(site_id: s.id, ref_category_vertical_id: r.id, name: "Youtube", url: s.youtube_url, launch_in_new_window: true, account_id: s.account_id)
          end
        end
      end
      SiteVerticalNavigation.all.update_all(menu: "Vertical Header")
    end
end