namespace :ceew_districts do
    task load: :environment do
        ceew_account = Rails.env.development? ? Account.friendly.find('pykih') : Account.friendly.find('ceew')
        ceew_site = ceew_account.site
        current_user = User.find(2)
        template_page = TemplatePage.where(name: 'article').first
        district_folder = Rails.env.development? ? Folder.friendly.find('test') : Folder.find(502) # Pages Folder
        district_parameters_folder = Rails.env.development? ? Folder.friendly.find('test') : Folder.friendly.find('district-about-and-parameters') # Summary, About and Parameters
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

            # Creating parameter cards

            # Creating Policy Cards

            # Publish the stream
            hero_stream.publish_cards
            narrative_stream.publish_cards
            related_stream.publish_cards

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

    task load: :environment do
        ceew_account = Rails.env.development? ? Account.friendly.find('pykih') : Account.friendly.find('ceew')
        ceew_site = ceew_account.site
        current_user = User.find(2)
        template_page = TemplatePage.where(name: 'article').first
        district_folder = Rails.env.development? ? Folder.friendly.find('test') : Folder.find(502) # Pages Folder
        district_parameters_folder = Rails.env.development? ? Folder.friendly.find('test') : Folder.friendly.find('district-about-and-parameters') # Summary, About and Parameters
        district_policy_folder = Rails.env.development? ? Folder.friendly.find('test') : Folder.find(503) # DA and Policy
        # Create all the pages
        all_districts = JSON.parse(File.read("#{Rails.root.to_s}/ref/ceew/summary.json"))

        all_districts.each do |d|
            headline = "#{d["District"]}, #{d["State"]}"
            page = Page.where(headline: headline).first
            if page.present?
                puts "#{headline} - Found"
                puts "========"
            else
                ss
            end
        end

    end
end