class PagePublisher
  include Sidekiq::Worker
  sidekiq_options :backtrace => true

  def perform(page_id, skip_invalidation=false)
    page = Page.find(page_id)
    page.skip_invalidation = page.skip_invalidation || skip_invalidation
    page.push_page_object_to_s3
  end
end