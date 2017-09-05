class CsvErrorWorker
  include Sidekiq::Worker
  sidekiq_options :backtrace => true

  def perform(*args)
    # Do something
  end
end
