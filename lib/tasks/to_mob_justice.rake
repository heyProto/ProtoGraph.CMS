require 'json'
require 'csv'

namespace :to_mob_justice do
    task :load => :environment do
        csv_data = CSV.read(Rails.root.join('ref/to_mob_justice.csv'), headers: true)
        account_id = Account.friendly.find('indianexpress').id
        template_datum_id = TemplateDatum.friendly.where(name: "toReportViolence").first.id
        template_card_id = TemplateCard.friendly.where(name: "toReportViolence").first.id
        csv_data.each do |d|
            data = d.to_hash
            #=================
            #Creating Viewcast
            #=================
            a = ViewCast.new
            a.name = data["title"]
            a.account_id = account_id
            a.template_card_id = template_card_id
            a.template_datum_id = template_datum_id
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
            data["headline"] = data["headline"].to_s.strip
            data["url"] = data["url"].to_s.strip
            data["story_source"] = data["story_source"].to_s.strip
            data["story_source_summary"] = data["story_source_summary"].to_s.strip
            data["date"] = data["date"].to_s.strip
            data["image"] = data["image"].to_s.strip
            data["state"] = data["state"].to_s.strip
            data["district"] = data["district"].to_s.strip
            data["area"] = data["area"].to_s.strip
            data["area_classification"] = data["area_classification"].to_s.strip
            data["state_ruling_party"] = data["state_ruling_party"].to_s.strip
            data["police_to_population"] = data["police_to_population"].to_s.strip
            data["judge_to_population"] = data["judge_to_population"].to_s.strip
            data["lat"] = data["lat"].to_f
            data["lng"] = data["lng"].to_f
            data["victim_religion"] = data["victim_religion"].to_s.strip
            data["victim_tag"] = data["victim_tag"].to_s.strip
            data["victim_gender"] = data["victim_gender"].to_s.strip
            data["victim_action"] = data["victim_action"].to_s.strip
            data["accused_religion"] = data["accused_religion"].to_s.strip
            data["accused_tag"] = data["accused_tag"].to_s.strip
            data["accused_gender"] = data["accused_gender"].to_s.strip
            data["accused_action"] = data["accused_action"].to_s.strip
            data["the_lynching"] = data["the_lynching"].to_s.strip
            data["count_injured"] = data["count_injured"].to_i
            data["count_dead"] = data["count_dead"].to_i
            data["victim_names"] = data["victim_names"].to_s.strip
            data["title"] = data["title"].to_s.strip
            data["how_was_the_lynching_planned"] = data["how_was_the_lynching_planned"].to_s.strip
            data["accused_names"] = data["accused_names"].to_s.strip
            data["did_the_police_intervene_and_prevent_the_death?"] = data["did_the_police_intervene_and_prevent_the_death?"].to_s.strip
            data["does_the_state_criminalise_victims_actions"] = data["does_the_state_criminalise_victims_actions"].to_s.strip
            data["what_the_victim_did"] = data["what_the_victim_did"].to_s.strip
            data["what_was_the_mob_doing"] = data["what_was_the_mob_doing"].to_s.strip
            data["menu"] = data["menu"].to_s.strip
            data["is_notable_incident"] = data["is_notable_incident"].to_s.strip
            obj['data'] = data
            payload["payload"] = obj.to_json
            payload["source"]  = "backgroud_job"
            payload["api_slug"] = a.datacast_identifier
            payload["schema_url"] = a.template_datum.schema_json
            r = Api::ProtoGraph::Datacast.create(payload)
            puts "==========================="
            puts r["errorMessage"]
            if r.has_key?('errorMessage')
                a.delete
            end
            puts "==========================="
            Thread.new do
                a.save_png
                ActiveRecord::Base.connection.close
            end
        end

    end

    task :cleanup => :environment do
        ViewCast.where(template_card_id: TemplateCard.where(name: 'toReportViolence').first.id).destroy_all
    end


    task :create_json => :environment do
        view_casts = ViewCast.where(template_card_id: TemplateCard.where(name: 'toReportViolence').first.id)
        cattle_protection_json = []
        crime_json = []
        sexual_harrassment_json = []
        witch_craft_json = []
        honour_killing_json = []
        other_json = []
        all_data = []
        view_casts.each do |view_cast|
            res = JSON.parse(RestClient.get(view_cast.data_url).body)
            data = res['data']
            data['view_cast_id'] = view_cast.datacast_identifier
            data['schema_id'] = view_cast.template_datum.s3_identifier
            data['screen_shot_url'] = view_cast.render_screenshot_url
            data['date'] = Date.parse(data['date']).strftime("%d %b '%y")
            all_data << data
            puts "================="
        end

        #Sorting the data
        all_data = all_data.sort_by{|d| Date.parse(d['date'])}.reverse!

        puts  "Uploading Index"
        key = "toMobJustice/index.json"
        encoded_file = Base64.encode64(all_data.to_json)
        content_type = "application/json"
        resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, key, content_type)

    end
end