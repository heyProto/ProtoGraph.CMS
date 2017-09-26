class ColorUpdateWorker
  include Sidekiq::Worker
  sidekiq_options :backtrace => true

  def perform(account_id)
    a = Account.find(account_id)
    a.view_casts.where(template_card_id: TemplateCard.where(name: 'toArticle').first.id).each do |view_cast|
      view_cast.update(optionalConfigJSON: {"house_colour": a.house_colour}.to_json)
      key = "#{view_cast.datacast_identifier}/view_cast.json"
      if a.cdn_id != ENV['AWS_CDN_ID']
        Api::ProtoGraph::CloudFront.invalidate(a, ["/#{key}"], 1)
      end
      Api::ProtoGraph::CloudFront.invalidate(nil, ["/#{key}"], 1)
    end

  end
end
