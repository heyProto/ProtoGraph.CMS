require 'csv'
namespace :seed do

    task :db => :environment do
        if Rails.env.development?
            begin
                Rake::Task['db:drop'].invoke
            rescue
            end
            begin
                Rake::Task['db:create'].invoke
            rescue
            end
        end

        Rake::Task['db:migrate'].invoke
        Rake::Task['seed:users'].invoke
        RefRole.seed
    end




    task :users => :environment do |t, args|
        puts "----> Creating users"
        accounts = [["ritvvij.parrikh@pykih.com", "Ritvvij Parrikh" ,"ritvvijparrikh"], ["ab@pykih.com", "Amit Badheka", "amitbadheka"]]
        accounts.each do |a|
          c = User.new(email: a[0], name: a[1], username: a[2], password: "indianmonsoon1234801" , confirmation_sent_at: Time.now)
          c.skip_confirmation!
          c.save
        end
    end
end