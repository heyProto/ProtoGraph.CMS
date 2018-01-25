class PagesWorker
  include Sidekiq::Worker
  sidekiq_options :backtrace => true

  def perform(page_id)
    page = Page.find(page_id)
    case page.layout
    when 'section'
      Pages::SectionPageWorker.perform_at(10.seconds.from_now, page_id)
    when 'article'
      Pages::ArticlePageWorker.perform_at(10.seconds.from_now, page_id)
    when 'data grid'
      Pages::DataPageWorker.perform_at(10.seconds.from_now, page_id)
    else
    end
  end

end