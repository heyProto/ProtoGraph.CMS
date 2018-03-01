task :update_card_data => :environment do
    puts "Updating the quiz cards....."
    update_quiz_cards

    puts "Updating the timeline cards....."
    update_timeline_cards

    puts "Updating the compose cards....."
    update_compose_cards

    puts "Updating the cluster cards....."
    update_cluster_cards
end

def update_quiz_cards
    template_card = TemplateCard.find_by_name('toQuiz')
    cards = template_card.view_casts
    cards.each do |card|
        begin
            data = JSON.parse(RestClient.get(card.data_url))
            data["data"]["section"] = data["data"]["basic_datapoints"]["quiz_title"]
            encoded_file = Base64.encode64(data.to_json)
            content_type = "application/json"
            resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, "#{card.datacast_identifier}/data.json", content_type, card.site.cdn_bucket)
            Api::ProtoGraph::CloudFront.invalidate(card.site, ["/#{card.datacast_identifier}/data.json"], 1)
        rescue => exception
            puts "=========================== #{card.id}-#{card.datacast_identifier} #{exception.inspect} ==========================="
        end
    end
end

def update_timeline_cards
    template_card = TemplateCard.find_by_name('toTimeline')
    cards = template_card.view_casts
    cards.each do |card|
        begin
            data = JSON.parse(RestClient.get(card.data_url))
            data["data"]["section"] = data["mandatory_config"]["timeline_title"]
            encoded_file = Base64.encode64(data.to_json)
            content_type = "application/json"
            resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, "#{card.datacast_identifier}/data.json", content_type, card.site.cdn_bucket)
            Api::ProtoGraph::CloudFront.invalidate(card.site, ["/#{card.datacast_identifier}/data.json"], 1)
        rescue => exception
            puts "=========================== #{card.id}-#{card.datacast_identifier} #{exception.inspect} ==========================="
        end
    end
end

def update_compose_cards
    template_card = TemplateCard.find_by_name('toParagraph')
    cards = template_card.view_casts
    cards.each do |card|
        begin
            data = JSON.parse(RestClient.get(card.data_url))
            data["data"]["section"] = Page.get_section(data["data"]["text"])
            encoded_file = Base64.encode64(data.to_json)
            content_type = "application/json"
            resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, "#{card.datacast_identifier}/data.json", content_type, card.site.cdn_bucket)
            Api::ProtoGraph::CloudFront.invalidate(card.site, ["/#{card.datacast_identifier}/data.json"], 1)
        rescue => exception
            puts "=========================== #{card.id}-#{card.datacast_identifier} #{exception.inspect} ==========================="
        end
    end
end

def update_cluster_cards
    template_card = TemplateCard.find_by_name('toCluster')
    cards = template_card.view_casts
    cards.each do |card|
        begin
            data = JSON.parse(RestClient.get(card.data_url))
            data["data"]["section"] = data["data"]["title"]
            encoded_file = Base64.encode64(data.to_json)
            content_type = "application/json"
            resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, "#{card.datacast_identifier}/data.json", content_type, card.site.cdn_bucket)
            Api::ProtoGraph::CloudFront.invalidate(card.site, ["/#{card.datacast_identifier}/data.json"], 1)
        rescue => exception
            puts "=========================== #{card.id}-#{card.datacast_identifier} #{exception.inspect} ==========================="
        end
    end
end