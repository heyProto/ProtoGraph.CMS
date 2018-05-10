class FeedsWorker
    include Sidekiq::Worker
    sidekiq_options :backtrace => true

    require 'rss'
    require 'open-uri'

    def perform(ref_category_id, feed_id, skip_scheduling=false)
      begin
        ref_category = RefCategory.find(ref_category_id)
        feed = Feed.find(feed_id)
        feed.update_column(:custom_errors, "")
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

        unless skip_scheduling
          feed.update_attributes(last_refreshed_at: Time.now, next_refreshed_scheduled_for: (Time.now + (5*60*60)))
          FeedsWorker.perform_in(5.hours, ref_category_id, feed_id)
        else
          feed.update_attributes(last_refreshed_at: Time.now)
        end
      rescue Exception => e
        feed = Feed.find(feed_id)
        unless skip_scheduling
          feed.update_attributes(
            last_refreshed_at: Time.now,
            next_refreshed_scheduled_for: (Time.now + (5*60*60)),
            custom_errors: "Error fetching and parsing feeds from the given URL."
          )
          FeedsWorker.perform_in(5.hours, ref_category_id, feed_id)
        else
          feed.update_attributes(
            last_refreshed_at: Time.now,
            custom_errors: "Error fetching and parsing feeds from the given URL."
          )
        end
      end
    end
end