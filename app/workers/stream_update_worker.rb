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
    series = site.ref_categories.where(genre: "series",name: view_cast.series).first
    if series.present? and series.stream.present?
      series.stream.publish_cards
      series.stream.publish_rss
    end
    #genre
    genre = site.ref_categories.where(genre: "intersection", name: view_cast.genre).first
    if genre.present? and genre.stream.present?
      genre.stream.publish_cards
      genre.stream.publish_rss
    end
    #sub_genre
    sub_genre = site.ref_categories.where(genre: "sub intersection",name: view_cast.sub_genre).first
    if sub_genre.present? and sub_genre.stream.present?
      sub_genre.stream.publish_cards
      sub_genre.stream.publish_rss
    end
  end
end
