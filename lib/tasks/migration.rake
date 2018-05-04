namespace :migration do
    task temp: :environment do
      RefCategory.where(genre: "series").update_all(show_by_publisher_in_header: true)
      SiteVerticalNavigation.all.update_all(menu: "Vertical Header")
    end
end