class LcwDataUpdateWorker
  include Sidekiq::Worker
  sidekiq_options :backtrace => true
  require 'csv'

  def perform
    csv_text = open("https://www.landconflictwatch.org/csv_published")
    data = CSV.parse(csv_text, headers: true)
  end

end