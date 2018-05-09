class FeedsWorker
    include Sidekiq::Worker
    sidekiq_options :backtrace => true

    require 'rss'
    require 'open-uri'

    def perform(ref_category_id, feed_id)
      ref_category = RefCategory.find(ref_category_id)
      feed = Feed.find(feed_id)
      rss = open(feed.rss)
      rss_xml = RSS::Parser.parse(rss)
      rss_xml.items.each do |item|
        f = FeedLink.where(ref_category_id: ref_category_id, link: item.link).first
        if f.blank?
          FeedLink.create(ref_category_id: ref_category_id, feed_id: feed_id, link: item.link, headline: item.title, published_at: item.pubDate, description: item.description)
        elsif f.view_cast_id.blank?
          f.update_attributes(headline: item.title, published_at: item.pubDate, description: item.description)
        end
      end
      feed.update_attributes(last_refreshed_at: Time.now, next_refreshed_scheduled_for: (Time.now + (5*60*60)))
      FeedsWorker.perform_in(5.hours, ref_category_id, feed_id)
    end
end