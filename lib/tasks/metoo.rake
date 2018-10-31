namespace :spotlight do
    task load_metoo_cards: :environment do
        project_site = Rails.env.development? ? Site.friendly.find('pyktest') : Site.friendly.find('projects')
        current_user = User.find(2)
        template_card = TemplateCard.where(name: 'ToRecordMeToo').first
        all_crimes = JSON.parse(File.read("#{Rails.root.to_s}/ref/spotlight/metoo.json"))
        folder = Rails.env.development? ? Folder.friendly.find('metoo') : Folder.friendly.find('database')
        all_crimes.each do |d|
            name = "#{d['accused_name']} - #{d['complainant_name']}"
            data = {}
            data["data"] = d
            data["data"]['created_at'] = DateTime.strptime(d['created_at'], '%d/%m/%Y %H:%M:%S')
            payload = {}
            payload["payload"] = data.to_json
            payload["source"]  = "form"
            card = ViewCast.create({
                site_id: project_site.id,
                name: name,
                seo_blockquote: "",
                folder_id: folder.id,
                ref_category_vertical_id: folder.ref_category_vertical_id,
                template_card_id: template_card.id,
                template_datum_id:  template_card.template_datum_id,
                created_by: current_user.id,
                updated_by: current_user.id,
                optionalconfigjson: {},
                data_json: data
            })

            payload["api_slug"] = card.datacast_identifier
            payload["schema_url"] = card.template_datum.schema_json
            payload["bucket_name"] = project_site.cdn_bucket

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