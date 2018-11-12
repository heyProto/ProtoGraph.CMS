require 'csv'
require 'json'


namespace :util do
    task :convert_cards, [:stream_id, :template_card_id] => [:environment] do |task, args|
        puts args[:stream_id], args[:template_card_id]
        
        current_cards = Stream.find(args[:stream_id]).cards.where(:template_card_id => args[:template_card_id])
        csv_string = CSV.open("file.csv", "wb") do |csv|
            csv << current_cards.first.data_json['data'].keys
            current_cards.each do |card|
                
                json_value = card.data_json['data']

                puts json_value.values

                csv << json_value.values
            end
        end
    end
end
