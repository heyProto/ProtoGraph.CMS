namespace :image_cards do
    task migrate: :environment do
        #Migrate All Image Narrative Cards
        ViewCast.where(template_card_id: TemplateCard.where(name: 'toImageNarrative').pluck(:id)).each do |d|
            data_json = d.data_json
            next if d.data_json['data'].has_key?('img_url')
            data_obj = {}
            data_obj["img_url"] = data_json["data"]["url_7column"]
            data_obj["caption"] = data_json["data"]["credit"] unless data_json["data"]['credit'].blank?
            data_obj['caption_url'] = data_json["data"]["credit_link"] unless data_json["data"]['credit_link'].blank?
            d.data_json = {"data"=>data_obj}
            d.save
        end

        #Migrate All Cover Cards
        ViewCast.where(template_card_id: TemplateCard.where(name: 'toCoverImage').pluck(:id)).each do |d|
            data_json = d.data_json
            next if d.data_json['data'].has_key?('img_url')
            data_obj = {}
            data_obj["img_url"] = data_json["data"]["url_16column"]
            d.data_json = {"data"=>data_obj}
            d.save
        end
    end
end