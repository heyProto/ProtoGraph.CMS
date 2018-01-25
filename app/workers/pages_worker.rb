class PagesWorker
  include Sidekiq::Worker
  sidekiq_options :backtrace => true

  def perform(page_id, stream_id, page_stream_id)
  end

end