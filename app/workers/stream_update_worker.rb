class StreamUpdateWorker
  include Sidekiq::Worker
  sidekiq_options :backtrace => true

  def perform(view_cast_id)
    view_cast = ViewCast.find(view_cast_id)
    site = view_cast.site
    site.stream.publish_cards
    site.stream.publish_rss
    # by_line will get it done when we bring by_line concepts in
    permission = Permission.where(id: view_cast.byline_id).first
    if permission.present? and permission.stream.present?
      permission.stream.publish_cards
      permission.stream.publish_rss
    end
    #Series
    series = view_cast.series
    if series.present? and series.stream.present?
      series.stream.publish_cards
      series.stream.publish_rss
    end
    #genre
    genre = view_cast.intersection
    if genre.present? and genre.stream.present?
      genre.stream.publish_cards
      genre.stream.publish_rss
    end
    #sub_genre
    sub_genre = view_cast.sub_intersection
    if sub_genre.present? and sub_genre.stream.present?
      sub_genre.stream.publish_cards
      sub_genre.stream.publish_rss
    end
  end
end
