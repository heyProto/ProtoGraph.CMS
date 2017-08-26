class PiwikDatacastMetricWorker
  include Sidekiq::Worker
  sidekiq_options backtrace: true

  def perform(datacast_identifier)
    
  end
end
