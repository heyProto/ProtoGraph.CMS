class PublishSiteJson
  include Sidekiq::Worker
  sidekiq_options :backtrace => true

  def perform(site_id, skip_invalidation=false)
    site = Site.find(site_id)
    site.skip_invalidation = site.skip_invalidation || skip_invalidation
    header_json = {
        "header_logo_url": "#{site.logo_image_id.present? ? site.logo_image.original_image.image_url : ''}",
        "header_background_color": "#{site.header_background_color}",
        "header_jump_to_link": "#{site.header_url}",
        "header_logo_position": "#{site.header_positioning}",
        "house_colour": "#{site.house_colour}",
        "reverse_house_colour": "#{site.reverse_house_colour}",
        "font_colour": "#{site.font_colour}",
        "reverse_font_colour": "#{site.reverse_font_colour}",
        "primary_language": "#{site.primary_language}",
        "story_card_style": "#{site.story_card_style}",
        "story_card_flip": site.story_card_flip,
        "favicon_url": "#{site.favicon.present? ? site.favicon.image_url : ""}",
        "show_proto_logo": site.show_proto_logo
    }
    key = "#{site.header_json_key}"
    encoded_file = Base64.encode64(header_json.to_json)
    content_type = "application/json"
    resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, key, content_type, site.cdn_bucket)
    unless site.skip_invalidation
      Api::ProtoGraph::CloudFront.invalidate(site, ["/#{key}"], 1)
    end
  end

end