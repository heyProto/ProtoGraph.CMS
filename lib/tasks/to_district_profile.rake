require 'json'
require 'csv'

namespace :to_district_profile do
    task :load_streams => :environment do
        all_districts = ["Agra","Aligarh","Allahabad","Ambedkar Nagar","Amethi","Amroha","Auraiya","Azamgarh","Baghpat","Bahraich","Ballia","Balrampur","Banda","Barabanki","Bareilly","Basti","Bhadohi","Bijnor","Budaun","Bulandshahar","Chandauli","Chitrakoot","Deoria","Etah","Etawah","Faizabad","Farrukhabad","Fatehpur","Firozabad","Gautam Buddha Nagar","Ghaziabad","Ghazipur","Gonda","Gorakhpur","Hamirpur","Hapur","Hardoi","Hathras","Jalaun","Jaunpur","Jhansi","Kannauj","Kanpur Dehat","Kanpur Nagar","Kasganj","Kaushambi","Kushinagar","Lakhimpur Kheri","Lalitpur","Lucknow","Maharajganj","Mahoba","Mainpuri","Mathura","Mau","Meerut","Mirzapur","Moradabad","Muzaffarnagar","Pilibhit","Pratapgarh","Raebareli","Rampur","Saharanpur","Sambhal","Sant Kabir Nagar","Shahjahanpur","Shamli","Shravasti","Siddharth Nagar","Sitapur","Sonbhadra","Sultanpur","Unnao","Varanasi"]
        account = Account.friendly.find('jagran')
        user = account.users.first
        #initialising folders
        district_folder = account.folders.where(name: "districts").first
        mp_folder = account.folders.where(name: "MP").first
        land_use_folder = account.folders.where(name: "Land use").first
        rainfall_folder = account.folders.where(name: "Rainfall").first
        water_exploitation_folder = account.folders.where(name: "Water Exploitation").first
        streams_folder = account.folders.where(name: "Streams").first

        #initialising template_cards
        district_template_card = account.template_cards.where(name: "toDistrictProfile").first
        mp_template_card = account.template_cards.where(name: "toPoliticalLeadership").first
        land_use_template_card = account.template_cards.where(name: "toLandUse").first
        rainfall_template_card = account.template_cards.where(name: "toRainfall").first
        water_exploitation_template_card = account.template_cards.where(name: "toWaterExploitation").first


        all_districts.each do |district|
            stream = Stream.new(title: district, folder_id: streams_folder.id,created_by: user.id, updated_by: user.id, datacast_identifier: district.parameterize, account_id: account.id)
            district_card = district_folder.view_casts.where(template_card_id: district_template_card.id, name: district).first
            mp_card = mp_folder.view_casts.where(template_card_id: mp_template_card.id, name: district).first
            land_use_card = land_use_folder.view_casts.where(template_card_id: land_use_template_card.id, name: district).first
            rainfall_card = rainfall_folder.view_casts.where(template_card_id: rainfall_template_card.id, name: district).first
            water_exploitation_card = water_exploitation_folder.view_casts.where(template_card_id: water_exploitation_template_card.id, name: district).first

            view_cast_ids = []
            view_cast_ids << district_card.id if district_card.present?
            view_cast_ids << mp_card.id if mp_card.present?
            view_cast_ids << land_use_card.id if land_use_card.present?
            view_cast_ids << rainfall_card.id if rainfall_card.present?
            view_cast_ids << water_exploitation_card.id if water_exploitation_card.present?

            stream.view_cast_id_list = [view_cast_ids.join(",")]
            stream.save
            stream.publish_cards
        end
    end
end