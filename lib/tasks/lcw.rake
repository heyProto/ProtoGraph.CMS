namespace :lcw do
    task load_cards: :environment do
        lcw_account = Rails.env.development? ? Account.friendly.find('pykih') : Account.friendly.find('landconflictwatch')
        lcw_site = lcw_account.site
        current_user = User.find(2)
        template_card = TemplateCard.where(name: 'toRecordLandConflict').first
        all_crimes = JSON.parse(File.read("#{Rails.root.to_s}/ref/lcw/data.json"))
        folder = Rails.env.development? ? Folder.friendly.find('lcw') : Folder.friendly.find('conflicts')
        all_crimes.each do |d|
            name = "#{d['name_of_conflict']}"
            data = {}
            d['no_of_household_affected'] = d['no_of_household_affected'].to_s
            d["investment"] = d["investment"].to_s
            d['land_area_affected'] = d['land_area_affected'].to_s
            d["year"] = d["year"].to_s
            data["data"] = d
            payload = {}
            payload["payload"] = data.to_json
            payload["source"]  = "form"
            seo_blockquote = "<blockquote><h1>#{name}</h1><p>#{d["nature_of_land_conflict"]}</p><p>#{d["district"]}</p><p>#{d["state"]}</p><p>#{d["type_of_industry"]}</p><p>#{d['summary']}</p></blockquote>"
            card = ViewCast.create({
                site_id: lcw_site.id,
                account_id: lcw_account.id,
                name: name,
                seo_blockquote: seo_blockquote,
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
            payload["bucket_name"] = lcw_site.cdn_bucket

            r = Api::ProtoGraph::Datacast.create(payload)
            if r.has_key?("errorMessage")
                card.destroy
                puts r['errorMessage']
                puts "================="
            else
                puts "Saved Record Conflict Card"
            end
        end
    end
end