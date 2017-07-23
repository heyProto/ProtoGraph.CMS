require 'json'
require 'csv'

namespace :to_mob_justice do
    task :load => :environment do
        csv_data = CSV.read(Rails.root.join('ref/to_mob_justice.csv'), headers: true)
        account_id = Account.friendly.find('indianexpress').id
        template_datum_id = TemplateDatum.friendly.where(name: "toMobJustice").first.id
        template_card_id = TemplateCard.friendly.where(name: "toMobJustice").first.id
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
            data["url"] = data["url"].to_s.strip
            data["title"] = data["title"].to_s.strip
            data["menu"] = data["menu"].to_s.strip
            data["sub_crime"] = data["sub_crime"].to_s.strip
            data["date"] = data["date"].to_s.strip
            data["area"] = data["area"].to_s.strip
            data["state"] = data["state"].to_s.strip
            data["state_ruling_party"] = data["state_ruling_party"].to_s.strip
            data["image"] = data["image"].to_s.strip
            data["victim_religion"] = data["victim_religion"].to_s.strip
            data["victim_tag"] = data["victim_tag"].to_s.strip
            data["victim_gender"] = data["victim_gender"].to_s.strip
            data["victim_action"] = data["victim_action"].to_s.strip
            data["victim_names"] = data["victim_names"].to_s.strip
            data["accused_religion"] = data["accused_religion"].to_s.strip
            data["accused_tag"] = data["accused_tag"].to_s.strip
            data["accused_gender"] = data["accused_gender"].to_s.strip
            data["accused_names"] = data["accused_names"].to_s.strip
            data["accused_action"] = data["accused_action"].to_s.strip
            data["the_lynching"] = data["the_lynching"].to_s.strip
            data["count_injured"] = data["count_injured"].to_i
            data["count_dead"] = data["count_dead"].to_i
            data["does_the_state_criminalise_victims_actions"] = data["does_the_state_criminalise_victims_actions"].to_s.strip
            data["which_law"] = data["which_law"].to_s.strip
            data["lat"] = data["lat"].to_f
            data["lng"] = data["lng"].to_f
            data["police_to_population"] = data["police_to_population"].to_s.strip
            data["judge_to_population"] = data["judge_to_population"].to_s.strip
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
        ViewCast.where(template_card_id: TemplateCard.where(name: 'toMobJustice').first.id).destroy_all
    end


    task :create_json => :environment do
        view_casts = ViewCast.where(template_card_id: TemplateCard.where(name: 'toMobJustice').first.id)
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
            case data['menu']
            when "Cattle Protection"
                cattle_protection_json << data
            when "Crime"
                crime_json << data
            when "Sexual Harrassment"
                sexual_harrassment_json << data
            when "Witch Craft"
                witch_craft_json << data
            when "Honour Killing"
                honour_killing_json << data
            else
                other_json << data
            end
            all_data << data
            puts "================="
        end

        #Sorting the data
        cattle_protection_json = cattle_protection_json.sort_by{|d| Date.parse(d['date'])}.reverse!
        crime_json = crime_json.sort_by{|d| - d['date']}.reverse!
        sexual_harrassment_json = sexual_harrassment_json.sort_by{|d| Date.parse(d['date'])}.reverse!
        witch_craft_json = witch_craft_json.sort_by{|d| Date.parse(d['date'])}.reverse!
        honour_killing_json = honour_killing_json.sort_by{|d| Date.parse(d['date'])}.reverse!
        other_json = other_json.sort_by{|d| Date.parse(d['date'])}.reverse!
        all_data = all_data.sort_by{|d| Date.parse(d['date'])}.reverse!

        puts "Uploading Cattle Protection"
        key = "toMobJustice/cattle_protection.json"
        encoded_file = Base64.encode64(cattle_protection_json.to_json)
        content_type = "application/json"
        resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, key, content_type)


        puts "Uploading crime"
        key = "toMobJustice/crime.json"
        encoded_file = Base64.encode64(crime_json.to_json)
        content_type = "application/json"
        resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, key, content_type)

        puts "Uploading Sexual Harrassment"
        key = "toMobJustice/sexual_harrassment.json"
        encoded_file = Base64.encode64(sexual_harrassment_json.to_json)
        content_type = "application/json"
        resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, key, content_type)

        puts "Uploading Witch Craft"
        key = "toMobJustice/witch_craft.json"
        encoded_file = Base64.encode64(witch_craft_json.to_json)
        content_type = "application/json"
        resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, key, content_type)

        puts  "Uploading Honor Kiling"
        key = "toMobJustice/honour_killing.json"
        encoded_file = Base64.encode64(honour_killing_json.to_json)
        content_type = "application/json"
        resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, key, content_type)

        puts  "Uploading Other"
        key = "toMobJustice/other.json"
        encoded_file = Base64.encode64(other_json.to_json)
        content_type = "application/json"
        resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, key, content_type)

        puts  "Uploading Index"
        key = "toMobJustice/index.json"
        encoded_file = Base64.encode64(all_data.to_json)
        content_type = "application/json"
        resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, key, content_type)

    end
end