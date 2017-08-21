require 'json'
require 'csv'

namespace :to_report_violence do
    task :load => :environment do
        csv_data = CSV.read(Rails.root.join('ref/to_report_violence.csv'), headers: true)
        account = Account.friendly.find('indianexpress')
        account_id = account.id
        folder_id = account.folders.first.id
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
            a.folder_id = folder_id
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
            object = {}
            copy_paste_from_article = {}
            when_and_where_it_occur = {}
            the_incident = {}
            the_people_involved = {}
            hate_crime = {}
            addendum = {}


            # Copy Paste From Article
            copy_paste_from_article["url"] = data["url"].to_s.strip
            copy_paste_from_article["headline"] = data["headline"].to_s.strip
            copy_paste_from_article["image"] = data["image"].to_s.strip

            # When and where it occur
            when_and_where_it_occur["approximate_date_of_incident"] = data["approximate_date_of_incident"].to_s.strip
            when_and_where_it_occur["area"] = data["area"].to_s.strip
            when_and_where_it_occur["district"] = data["district"].to_s.strip
            when_and_where_it_occur["area_classification"] = data["area_classification"].to_s.strip
            when_and_where_it_occur["state"] = data["state"].to_s.strip
            when_and_where_it_occur["party_whose_chief_minister_is_in_power"] = data["party_whose_chief_minister_is_in_power"].to_s.strip
            when_and_where_it_occur["lat"] = data["lat"].to_f
            when_and_where_it_occur["lng"] = data["lng"].to_f
            when_and_where_it_occur["police_vehicles_per_km"] = data["police_vehicles_per_km"].to_s.strip
            when_and_where_it_occur["does_state_have_village_defence_force"] = data["does_state_have_village_defence_force"].to_s.strip
            when_and_where_it_occur["police_to_population_in_state"] = data["police_to_population_in_state"].to_s.strip
            when_and_where_it_occur["judge_to_population_in_state"] = data["judge_to_population_in_state"].to_s.strip

            # The incident
            the_incident["count_injured"] = data["count_injured"].to_i
            the_incident["count_dead"] = data["count_dead"].to_i
            the_incident["did_the_police_intervene"] = data["did_the_police_intervene"].to_s.strip
            the_incident["did_the_police_intervention_prevent_death"] = data["did_the_police_intervention_prevent_death"].to_s.strip
            the_incident["what_the_victim_did"] = data["what_the_victim_did"].to_s.strip
            the_incident["what_was_the_mob_doing"] = data["what_was_the_mob_doing"].to_s.strip
            the_incident["describe_the_event"] = data["describe_the_event"].to_s.strip
            the_incident["classification"] = data["classification"].to_s.strip
            the_incident["was_incident_planned"] = data["was_incident_planned"].to_s.strip

            # The people involved
            the_people_involved["victim_names"] = data["victim_names"].to_s.strip
            the_people_involved["victim_social_classification"] = data["victim_social_classification"].to_s.strip
            the_people_involved["victim_social_classification_notes"] = data["victim_social_classification_notes"].to_s.strip
            the_people_involved["victim_sex"] = data["victim_sex"].to_s.strip
            the_people_involved["title"] = data["title"].to_s.strip
            the_people_involved["accused_names"] = data["accused_names"].to_s.strip
            the_people_involved["accused_social_classification"] = data["accused_social_classification"].to_s.strip
            the_people_involved["accused_social_classification_notes"] = data["accused_social_classification_notes"].to_s.strip
            the_people_involved["accused_sex"] = data["accused_sex"].to_s.strip


            # Hate Crime
            hate_crime["is_gender_hate_crime"] = data["is_gender_hate_crime"].to_s.strip
            hate_crime["is_caste_hate_crime"] = data["is_caste_hate_crime"].to_s.strip
            hate_crime["is_race_hate_crime"] = data["is_race_hate_crime"].to_s.strip
            hate_crime["is_religion_hate_crime"] = data["is_religion_hate_crime"].to_s.strip
            hate_crime["is_political_affiliation_hate_crime"] = data["is_political_affiliation_hate_crime"].to_s.strip
            hate_crime["is_sexual_orientation_and_gender_identity_hate_crime"] = data["is_sexual_orientation_and_gender_identity_hate_crime"].to_s.strip
            hate_crime["is_disability_hate_crime"] = data["is_disability_hate_crime"].to_s.strip
            hate_crime["is_ethnicity_hate_crime"] = data["is_ethnicity_hate_crime"].to_s.strip
            hate_crime["is_hate_crime"] = data["is_hate_crime"].to_s.strip


            # Addendum
            addendum["does_the_state_criminalise_victims_actions"] = data["does_the_state_criminalise_victims_actions"].to_s.strip
            addendum["which_law"] = data["which_law"].to_s.strip
            addendum["notes_to_explain_nuances"] = data["notes_to_explain_nuances"].to_s.strip
            addendum["referral_link_1"] = data["referral_link_1"].to_s.strip
            addendum["referral_link_2"] = data["referral_link_2"].to_s.strip
            addendum["referral_link_3"] = data["referral_link_3"].to_s.strip

            object["copy_paste_from_article"] = copy_paste_from_article
            object["when_and_where_it_occur"] = when_and_where_it_occur
            object["the_incident"] = the_incident
            object["the_people_involved"] = the_people_involved
            object["hate_crime"] = hate_crime
            object["addendum"] = addendum
            obj["data"] = object

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
        all_data = []
        view_casts.each do |view_cast|
            res = JSON.parse(RestClient.get(view_cast.data_url).body)
            data = res['data']
            d = {}
            d['view_cast_id'] = view_cast.datacast_identifier
            d['schema_id'] = view_cast.template_datum.s3_identifier
            d['screen_shot_url'] = view_cast.render_screenshot_url
            d['date'] = Date.parse(data["when_and_where_it_occur"]['approximate_date_of_incident']).strftime('%F')
            d['state'] = data["when_and_where_it_occur"]['state']
            d["area_classification"] = data["when_and_where_it_occur"]["area_classification"]
            d["lat"] = data["when_and_where_it_occur"]["lat"]
            d["lng"] = data["when_and_where_it_occur"]["lng"]
            d["title"] = data['the_people_involved']["title"]
            d["does_the_state_criminalise_victims_actions"] = data["addendum"]["does_the_state_criminalise_victims_actions"]
            d["party_whose_chief_minister_is_in_power"] =data["when_and_where_it_occur"]['party_whose_chief_minister_is_in_power']
            d["was_incident_planned"] = data["the_incident"]["was_incident_planned"]
            d["victim_social_classification"] = data["the_people_involved"]["victim_social_classification"]
            d["accused_social_classification"] = data["the_people_involved"]["accused_social_classification"]
            d["did_the_police_intervene"] = data["the_incident"]["did_the_police_intervene"]
            d["did_the_police_intervention_prevent_death"] = data["the_incident"]["did_the_police_intervene"]
            d["classification"] = data["the_incident"]["classification"]
            d["police_vehicles_per_km"] = data["when_and_where_it_occur"]["police_vehicles_per_km"]
            d["does_state_have_village_defence_force"] = data["when_and_where_it_occur"]["does_state_have_village_defence_force"]
            d["police_to_population_in_state"] = data["when_and_where_it_occur"]["police_to_population_in_state"]
            d["judge_to_population_in_state"] = data["when_and_where_it_occur"]["judge_to_population_in_state"]
            d["is_hate_crime"] = data["hate_crime"]["is_hate_crime"]
            d["is_gender_hate_crime"] = data["hate_crime"]["is_gender_hate_crime"]
            d["is_caste_hate_crime"] = data["hate_crime"]["is_caste_hate_crime"]
            d["is_race_hate_crime"] = data["hate_crime"]["is_race_hate_crime"]
            d["is_religion_hate_crime"] = data["hate_crime"]["is_religion_hate_crime"]
            d["is_political_affiliation_hate_crime"] = data["hate_crime"]["is_political_affiliation_hate_crime"]
            d["is_sexual_orientation_and_gender_identity_hate_crime"] = data["hate_crime"]["is_sexual_orientation_and_gender_identity_hate_crime"]
            d["is_disability_hate_crime"] = data["hate_crime"]["is_disability_hate_crime"]
            d["is_ethnicity_hate_crime"] = data["hate_crime"]["is_ethnicity_hate_crime"]
            d["which_law"] = data["addendum"]["which_law"]
            d['iframe_url']= "#{view_cast.template_card.index_html}?view_cast_id=#{view_cast.datacast_identifier}%26schema_id=#{view_cast.template_datum.s3_identifier}"

            all_data << d
        end

        #Sorting the data
        all_data = all_data.sort_by{|d| Date.parse(d['date'])}.reverse!

        puts  "Uploading Index"
        key = "toReportViolence/index.json"
        encoded_file = Base64.encode64(all_data.to_json)
        content_type = "application/json"
        resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, key, content_type)
        Api::ProtoGraph::CloudFront.invalidate(["/toReportViolence/index.json"], 1)
    end
end