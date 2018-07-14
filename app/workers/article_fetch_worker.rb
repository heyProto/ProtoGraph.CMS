class ArticleFetchWorker
  include Sidekiq::Worker
  sidekiq_options :backtrace => true

  def perform(url, site_id, page_id)
    begin
      page = Page.find(page_id)
      uri = URI("https://d9y49oyask.execute-api.ap-south-1.amazonaws.com/development/stories/")
      request_params =  {
        # urls: ["http://indianexpress.com/article/india/looking-ahead-in-2018-stories-that-will-take-center-stage-in-india-5004665/"]
        urls: [url]
      }
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      req = Net::HTTP::Post.new(uri.path)
      req.add_field("Content-Type", "application/json")
      req.body = request_params.to_json
      res = http.request(req)
      fetched_article_hash = JSON.parse(res.body)[0]

      page.headline = fetched_article_hash["Headline"]
      page.description = fetched_article_hash["Description"]
      page.content = fetched_article_hash["articleBody"]

      img_url = fetched_article_hash["Cover_image_url"]
      img_name = File.basename(URI.parse(img_url).path)

      page.build_cover_image(id: Image.maximum(:id).next, site_id: site_id, is_cover: true, description: fetched_article_hash["Cover_image_caption"])
      download_path = "public/"+page.cover_image.image.store_path
      Dir.mkdir(download_path) unless File.exists?("public/"+page.cover_image.image.store_path)
      open(download_path+img_name, 'wb') do |file|
        file << open(img_url).read
      end
      page.cover_image.image = Rails.root.join(download_path+img_name).open
      page.save
    rescue
      puts "Error Importing story"
    end
  end
end