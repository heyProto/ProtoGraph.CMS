namespace :ceew_districsts do
    task load: :environment do
        ceew_account = Rails.env.development? ? Account.friendly.find('pykih') : Account.friendly.find('ceew')
        ceew_site = ceew_account.site
        current_user = User.find(2)
        # Create all the pages

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
end