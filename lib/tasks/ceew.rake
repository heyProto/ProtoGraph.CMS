namespace :ceew_districts do
    task load: :environment do
        ceew_account = Rails.env.development? ? Account.friendly.find('pykih') : Account.friendly.find('ceew')
        ceew_site = ceew_account.site
        current_user = User.find(2)
        template_page = TemplatePage.where(name: 'article').first
        district_folder = Rails.env.development? ? Folder.friendly.find('test') : Folder.find(502) # Pages Folder
        district_policy_folder = Rails.env.development? ? Folder.friendly.find('test') : Folder.find(503) # DA and Policy
        # Create all the pages
        all_districts = JSON.parse(File.read("#{Rails.root.to_s}/ref/ceew/districts_profile.json"))
        t_profile_card = TemplateCard.where(name: "toProfile").first
        heroflow2_card_id = Rails.env.production? ? 7751  : 4485

        all_districts.each do |d|
            puts d
            puts "----------"
            district = d["District"]
            state = d["State"]
            headline = "#{district}, #{state}"
            puts headline
            puts "==========="
            page = Page.where(headline: headline).first
            if page.blank?
                page = Page.create({
                    site_id: ceew_site.id,
                    account_id: ceew_account.id,
                    headline: headline,
                    created_by: current_user.id,
                    updated_by: current_user.id,
                    folder_id: district_folder.id,
                    template_page_id: template_page.id,
                    byline_id: current_user.id,
                    english_headline: headline,
                    ref_category_series_id: district_folder.ref_category_vertical_id,
                    published_at: Time.now,
                    meta_keywords: "", meta_description: "", summary: ""
                })
            end

            hero_stream = page.streams.where(title: "#{page.id}_Story_16c_Hero").first

            narrative_stream = page.streams.where(title: "#{page.id}_Story_Narrative").first

            related_stream = page.streams.where(title: "#{page.id}_Story_Related").first

            StreamEntity.create({
                stream_id: hero_stream.id,
                entity_type: "view_cast_id",
                entity_value: "#{heroflow2_card_id}",
                created_by: current_user.id,
                updated_by: current_user.id,
                sort_order: 1
            })

            # Creating profile cards
            puts "creating profile card"

            datacast_params = {"data": {
                "title": headline,
                "description": " ",
                "image_url": d["image_url"],
                "details": [
                  {
                    "key": "Number of operational holdings",
                    "value": "#{d["Number of operational holdings"]}"
                  },
                  {
                    "key": "Average size of operational holding (Ha)",
                    "value": "#{d["Average size of operational holding (Ha)"]}"
                  },
                  {
                    "key": "No. of cultivators using diesel pumps",
                    "value": "#{d["No. of cultivators using diesel pumps"]}"
                  },
                  {
                    "key": "No. of cultivators using electric pumps",
                    "value": "#{d["No. of cultivators using electric pumps"]}"
                  },
                  {
                    "key": "Parameters",
                    "value": ""
                  }
                ],
                "section": headline
            }}

            payload = {}
            payload["payload"] = datacast_params.to_json
            payload["source"]  = "form"
            profile_card = ViewCast.create({
                site_id: ceew_site.id,
                account_id: ceew_account.id,
                name: headline,
                seo_blockquote: "",
                folder_id: district_folder.id,
                ref_category_vertical_id: district_folder.ref_category_vertical_id,
                template_card_id: t_profile_card.id,
                template_datum_id:  t_profile_card.template_datum_id,
                created_by: current_user.id,
                updated_by: current_user.id
            })
            payload["api_slug"] = profile_card.datacast_identifier
            payload["schema_url"] = profile_card.template_datum.schema_json
            payload["bucket_name"] = ceew_site.cdn_bucket

            r = Api::ProtoGraph::Datacast.create(payload)
            if r.has_key?("errorMessage")
                profile_card.destroy
                puts r['errorMessage']
                puts "================="
            else
                puts "Saved Profile Card"
            end

            StreamEntity.create({
                stream_id: related_stream.id,
                entity_type: "view_cast_id",
                entity_value: "#{profile_card.id}",
                created_by: current_user.id,
                updated_by: current_user.id,
                sort_order: 1
            })

            hero_stream.publish_cards
            narrative_stream.publish_cards

            # Publish the page
            page.status = "published"
            page.save
            puts "publishing page"
            puts "---------------------------"
            page.push_page_object_to_s3
        end

    end

    task create_data_pages: :environment do
        policies = [
            "Deployment Approach 1 - Private Ownership of pump",
            "Deployment Approach 2 - Solarization of feeders",
            "Deployment Approach 3 - Water-as-a-service",
            "Deployment Approach 4 - Promote 1 HP and sub-HP pump",
            "Har Khet ko Pani",
            "Per Drop More Crop",
            "Doubling cultivator's Income - capital investment",
            "Doubling cultivator's Income - crop intensity",
            "Doubling cultivator's Income - crop diversification",
            "National Mission on Oilseeds and Oil Palm (NMOOP)",
            "Sub-Mission on Agricultural Mechanisation - Farm Power Availability",
            "Climate Resilient Farming for Small Farms"
        ]

        account = Rails.env.development? ? Account.friendly.find('pykih') : Account.friendly.find('ceew')
        site = account.site
        folder =  Rails.env.development? ? site.folders.where.not(ref_category_vertical_id: nil).first : site.folders.where(slug: "da-and-policies").first
        template_page_id = TemplatePage.find_by(name: "Ceew: data grid").id

        policies.each do |p|
            begin
                page = Page.find_by(headline: p)
                unless page.present?
                    page = Page.create({
                        site_id: site.id,
                        account_id: account.id,
                        headline: p,
                        created_by: 2,
                        updated_by: 2,
                        folder_id: folder.id,
                        template_page_id: template_page_id,
                        byline_id: 2,
                        english_headline: p,
                        ref_category_series_id: folder.ref_category_vertical_id
                    })
                end

                page.status = "published"
                page.save

                page.push_page_object_to_s3
            rescue => e
                puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                puts "ERROR #{e}"
                puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
            end

            sleep 2.seconds
        end
    end

    task load_summary: :environment do
        puts "Adding Summary to all pages"
        all_districts = JSON.parse(File.read("#{Rails.root.to_s}/ref/ceew/summary.json"))

        all_districts.each do |d|
            headline = "#{d["District"]}, #{d["State"]}"
            page = Page.where(headline: headline).first
            if page.present?
                puts "#{headline}"
                puts "#{page.html_url}"
                puts "============="
                page.content = d["Summary"]
                page.prepare_cards_for_assembling= 'true'
                page.save
                page.push_page_object_to_s3
            end
        end
    end

    task load_parameters: :environment do
        puts "Adding All parameters"
        ceew_account = Rails.env.development? ? Account.friendly.find('pykih') : Account.friendly.find('ceew')
        ceew_site = ceew_account.site
        current_user = User.find(2)
        all_districts = JSON.parse(File.read("#{Rails.root.to_s}/ref/ceew/parameters.json"))
        district_parameters_folder = Rails.env.development? ? Folder.friendly.find('test') : Folder.friendly.find('district-about-and-parameters') # Summary, About and Parameters
        t_parameter_card = TemplateCard.where(name: 'Ceew: Parameter').first
        parameters_map = {
            "Unirrigated net sown area (Ha)" => ["unirrigated_net_sown_area_ha_value", "unirrigated_net_sown_area_ha_score"],
            "Area under horticulture crops as a share of gross cropped area (%)" => ["area_under_horticulture_crops_value", "area_under_horticulture_crops_score"],
            "Score on water scarcity index" => ["scarcity_index_score_value", "scarcity_index_score_score"],
            "Monthly per capita expenditure of rural agricultural households (INR)" => ["monthly_per_capita_expenditure_value", "monthly_per_capita_expenditure_score"],
            "Crop revenue per holding (INR)" => ["crop_revenue_value", "crop_revenue_score"],
            "No of rural and semi-urban bank branches per 10,000 cultivators" => ["bank_branches_value", "bank_branches_score"],
            "Medium and long term institutional credit disbursed in a year (in INR Crore)" => ["institutional_credit_disbursed_value", "institutional_credit_disbursed_score"],
            "No. of calls made to Kisan Call centre (between 1/1/2011 - 31/12/2015)" => ["calls_made_to_kcc_value", "calls_made_to_kcc_score"],
            "Level of farm mechanisation (tractors,harvesters, threshers per ha)" => ["farm_mechanisation_level_value", "farm_mechanisation_level_score"]
        }
        all_districts.each do |d|
            headline = "#{d["District"]}, #{d["State"]}"
            page = Page.where(headline: headline).first
            if page.present?
                puts "#{headline}"
                puts "#{page.html_url}"
                puts "============="
                related_stream = page.streams.where(title: "#{page.id}_Story_Related").first
                start_sort_order = 2
                parameters_map.each do |param, value|
                    puts param
                    puts "==========="
                    datacast_params = { "data": {
                            "title": param,
                            "display": d[value[0]],
                            "percentile": d[value[1]],
                            "district": d["District"]
                        }
                    }

                    payload = {}
                    payload["payload"] = datacast_params.to_json
                    payload["source"]  = "form"
                    profile_card = ViewCast.create({
                        site_id: ceew_site.id,
                        account_id: ceew_account.id,
                        name: "#{headline} - #{param}",
                        seo_blockquote: "",
                        folder_id: district_parameters_folder.id,
                        ref_category_vertical_id: district_parameters_folder.ref_category_vertical_id,
                        template_card_id: t_parameter_card.id,
                        template_datum_id:  t_parameter_card.template_datum_id,
                        created_by: current_user.id,
                        updated_by: current_user.id
                    })
                    payload["api_slug"] = profile_card.datacast_identifier
                    payload["schema_url"] = profile_card.template_datum.schema_json
                    payload["bucket_name"] = ceew_site.cdn_bucket

                    r = Api::ProtoGraph::Datacast.create(payload)
                    if r.has_key?("errorMessage")
                        profile_card.destroy
                        puts r['errorMessage']
                        puts "================="
                    else
                        puts "Saved Profile Card"
                    end

                    StreamEntity.create({
                        stream_id: related_stream.id,
                        entity_type: "view_cast_id",
                        entity_value: "#{profile_card.id}",
                        created_by: current_user.id,
                        updated_by: current_user.id,
                        sort_order: start_sort_order
                    })

                    start_sort_order += 1
                end
                related_stream.publish_cards
                page.push_page_object_to_s3
            end
        end

    end
end