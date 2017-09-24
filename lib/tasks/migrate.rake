namespace :migrate do
    task :update_current_db => :environment do
        Account.all.each do |a|
            a.update_attributes(house_colour: "000000")
        end
    end
end