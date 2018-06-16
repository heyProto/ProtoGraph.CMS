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

      if rss_xml.feed_type == 'rss'
        rss_xml.items.each do |item|
          create_or_update_feed_link(ref_category_id, feed_id, item.title, item.link, item.pubDate, item.description)
        end
      elsif rss_xml.feed_type == 'atom'
        rss_xml.items.each do |item|
          create_or_update_feed_link(ref_category_id, feed_id, item.title.content, item.link.href, item.published.content, item.content.content)
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

  private
  def create_or_update_feed_link(ref_category_id, feed_id, title, link, pubDate, description)
    f = FeedLink.where(ref_category_id: ref_category_id, link: link).first
    if f.blank?
      FeedLink.create(ref_category_id: ref_category_id, feed_id: feed_id, link: link, headline: title, published_at: pubDate, description: description)
    elsif f.view_cast_id.blank?
      f.update_attributes(headline: title, published_at: pubDate, description: description)
    end
  end
end