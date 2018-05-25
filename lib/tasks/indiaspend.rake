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
            payload = {}
            data = {}
            data["data"] = {}
            data["data"]["when_and_where"] = {}
            data["data"]["when_and_where"]["year"] = d["year"].to_s
            data["data"]["when_and_where"]["date"] = d["date"]
            data["data"]["when_and_where"]["district"] = d["district"]
            data["data"]["when_and_where"]["state"] = d["state"]
            data["data"]["when_and_where"]["latitude"] = d["latitude"]
            data["data"]["when_and_where"]["longitude"] = d["longitude"]
            data["data"]["description_of_incident"] = d["description_of_incident"]
            data["data"]["details"] = {}
            data["data"]["details"]["pretext_to_incident"] = d["pretext_to_incident"]
            data["data"]["details"]["type_of_assault"] = d["type_of_assault"]
            data["data"]["details"]["is_fir_registered"] = d["is_fir_registered"]
            data["data"]["details"]["religion_of_victim_1"] = d["religion_of_victim_1"]
            data["data"]["details"]["religion_of_victim_2"] = d["religion_of_victim_2"]
            data["data"]["details"]["religion_of_victim_3"] = d["religion_of_victim_3"]
            data["data"]["details"]["religion_of_other_victim"] = d["religion_of_other_victim"]
            data["data"]["details"]["religion_of_perpetrator_1"] = d["religion_of_perpetrator_1"]
            data["data"]["details"]["religion_of_perpetrator_2"] = d["religion_of_perpetrator_2"]
            data["data"]["details"]["religion_of_perpetrator_3"] = d["religion_of_perpetrator_3"]
            data["data"]["details"]["religion_of_other_perpetrator"] = d["religion_of_other_perpetrator"]
            data["data"]["details"]["party_in_power"] = d["party_in_power"]
            data["data"]["sources"] = {}
            data["data"]["sources"]["link_1"] = d["link_1"]
            data["data"]["sources"]["link_2"] = d["link_2"]
            data["data"]["sources"]["last_updated"] = d["last_updated"]
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