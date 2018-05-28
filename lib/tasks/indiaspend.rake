namespace :indiaspend do
    task load_hate_crime_cards: :environment do
        indiaspend_account = Rails.env.development? ? Account.friendly.find('pykih') : Account.friendly.find('indiaspend')
        indiaspend_site = indiaspend_account.site
        current_user = User.find(2)
        template_card = TemplateCard.where(name: 'toIndiaSpendCard').first
        all_crimes = JSON.parse(File.read("#{Rails.root.to_s}/ref/indiaspend/hatecrime.json"))
        folder = Rails.env.development? ? Folder.friendly.find('indiaspend') : Folder.friendly.find('cards')
        all_crimes.each do |d|
            name = "#{d['date']} - #{d['district']}, #{d['state']}"
            data = {}
            data["data"] = d
            payload = {}
            payload["payload"] = data.to_json
            payload["source"]  = "form"
            card = ViewCast.create({
                site_id: indiaspend_site.id,
                account_id: indiaspend_account.id,
                name: name,
                seo_blockquote: "",
                folder_id: folder.id,
                ref_category_vertical_id: folder.ref_category_vertical_id,
                template_card_id: template_card.id,
                template_datum_id:  template_card.template_datum_id,
                created_by: current_user.id,
                updated_by: current_user.id,
                optionalConfigJSON: {}
            })

            payload["api_slug"] = card.datacast_identifier
            payload["schema_url"] = card.template_datum.schema_json
            payload["bucket_name"] = indiaspend_site.cdn_bucket

            r = Api::ProtoGraph::Datacast.create(payload)
            if r.has_key?("errorMessage")
                card.destroy
                puts r['errorMessage']
                puts "================="
            else
                puts "Saved Profile Card"
            end
        end
    end
end