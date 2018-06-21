Image.find_each do |image|
    image.update_columns(site_id: image.account.site.id)
end