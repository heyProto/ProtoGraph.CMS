class PagePublisher
  include Sidekiq::Worker
  sidekiq_options :backtrace => true

  def perform(page_id)
    page = Page.find(page_id)
    page.push_page_object_to_s3
  end
end