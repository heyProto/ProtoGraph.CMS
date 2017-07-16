require 'json'

namespace :to_mob_justice do
    task :load => :environment do
        json_data = JSON.parse(File.read(Rails.root.join('ref/to_mob_justice.json')))
        account_id = Account.friendly.find('indianexpress').id
        template_datum_id = TemplateDatum.friendly.where(name: "toMobJustice").first
        template_card_id = TemplateCard.friendly.where(name: "toMobJustice").first
        json_data.each do |data|
            #=================
            #Creating Viewcast
            #=================
            a = ViewCast.new
            a.name = data["name"]
            a.account_id = 1
            a.template_card_id = 4
            a.template_datum_id = 13
            a.optionalConfigJSON = {
              "background_color": "white"
            }.to_json
            a.seo_blockquote = ""
            a.created_by = User.second.id
            a.updated_by = User.second.id
            a.stop_callback = true
            a.save!

            # #=================
            # #Creating Datacast
            # #=================

            payload = {}
            obj = {}
            data['lat'] = data['lat'].to_i
            data['lng'] = data['lng'].to_i
            obj['data'] = data
            payload["payload"] = obj.to_json
            payload["source"]  = "backgroud_job"
            payload["api_slug"] = a.datacast_identifier
            payload["schema_url"] = a.template_datum.schema_json
            r = Api::ProtoGraph::Datacast.create(payload)
            puts "==========================="
            puts r["errorMessage"]
            puts "==========================="

            a.save_png
        end

    end
end