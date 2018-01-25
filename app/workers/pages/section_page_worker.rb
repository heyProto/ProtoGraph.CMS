class Pages::SectionWorker
  include Sidekiq::Worker
  sidekiq_options :backtrace => true
  # 4 269 9
  def perform(page_id)
    require 'erb'
    @page = Page.find(page_id)
    page_object = JSON.parse(RestClient.get(@page.page_object_url).body)
    @streams = page_object["streams"]
    @site = page_object['site_attributes']

    @streams_mapping = {}
    @streams.each do |s|
      column = s['title'].split('_Section_').last;
      @streams_mapping[column] = s
    end

    section_template = File.read(Rails.root.join('app/views/pages/section.html.erb'))
    renderer = ERB.new(section_template)
    output = renderer.result()
    key = "#{@page.datacast_identifier}/section.html"
    encoded_file = Base64.encode64(output)
    content_type = "text/html"
    resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, key, content_type)
  end

end


