TemplateCard.find_each do |template_card|
    template_card.update_columns(site_id: template_card.account.site.id)
end