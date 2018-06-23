Image.find_each do |image|
    account_id = image.account_id
    if Account.exists?(id: account_id)
        account=Account.find(account_id)
        image.update_columns(site_id: account.site.id)
    else
        puts "Account with id=#{account_id} not found"
    end
end