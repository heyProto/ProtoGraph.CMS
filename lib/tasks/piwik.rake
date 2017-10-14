namespace :piwik do
  desc 'Jobs to fetch piwik data into the system.'
  task :fetch_metrics  => :environment do
    PiwikMetricWorker.perform_async
  end
end