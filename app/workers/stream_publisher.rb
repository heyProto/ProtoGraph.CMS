class StreamPublisher
  include Sidekiq::Worker
  sidekiq_options :backtrace => true

  def perform(stream_id)
    stream = Stream.find(stream_id)
    stream.publish_cards
    stream.publish_rss
  end

end