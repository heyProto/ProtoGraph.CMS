class Pages::SectionWorker
  include Sidekiq::Worker
  sidekiq_options :backtrace => true

  def perform(page_id, stream_id, page_stream_id)
    file = File.read(Rails.root.join('app/views/pages/section.html.erb'))
  end

end


