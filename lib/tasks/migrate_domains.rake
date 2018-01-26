namespace :migrate_domains do
  task :add => :environment do
    Account.all.each do |a|
      a.site.update_attributes(email_domain: a.domain, default_role: 'writer')
    end
  end
end