ImageVariation.find_each do |image_variation|
    if Image.exists?(id:image_variation.image_id)
        image=Image.find(image_variation.image_id)
        account_id = image.account_id
        if Account.exists?(id: account_id)
            account=Account.find(account_id)
            image_variation.update_columns(site_id: account.site.id)
        else
            puts "Account with id=#{account_id} not found"
        end
    end
end