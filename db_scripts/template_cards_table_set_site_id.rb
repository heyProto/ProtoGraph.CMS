TemplateCard.find_each do |template_card|
    account_id = template_card.account_id
    if Account.exists?(id: account_id)
        account=Account.find(account_id)
        template_card.update_columns(site_id: account.site.id)
    else
        puts "Account with id=#{account_id} not found"
    end
end