ImageVariation.find_each do |image_variation|
    if Image.exists?(id:image_variation.image_id)
        image=Image.find(image_variation.image_id)
        image_variation.update_columns(site_id: image.account.site.id)
    end
end