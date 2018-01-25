class StreamUpdateWorker
  include Sidekiq::Worker
  sidekiq_options :backtrace => true

  def perform(view_cast_id)
    view_cast = ViewCast.find(view_cast_id)
    site = view_cast.account.site
    #Site
    view_cast.sites.each do |s|
      s.stream.publish_cards
    end

    #by_line will get it done when we bring by_line concepts in
    # by_line = view_cast.account.users.where(name: view_cast.by_line).first
    # by_line.stream.publish_cards if by_line.present?
    #Series
    series = site.ref_categories.where(category: "series",name: view_cast.series).first
    series.stream.publish_cards if series.present?
    #genre
    genre = site.ref_categories.where(category: "genre",name: view_cast.genre).first
    genre.stream.publish_cards if genre.present?
    #sub_genre
    sub_genre = site.ref_categories.where(category: "sub_genre",name: view_cast.sub_genre).first
    sub_genre.stream.publish_cards if sub_genre.present?
  end
end
