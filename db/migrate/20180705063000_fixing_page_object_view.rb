class FixingPageObjectView < ActiveRecord::Migration[5.1]
  def change
    execute("Drop view page_objects;
    CREATE OR REPLACE VIEW page_objects AS
        SELECT vcs.datacast_identifier,
    vcs.view_cast_id,
    vcs.data_json,
    vcs.template_card_id,
    vcs.s3_identifier,
    vcs.seo_blockquote,
    vcs.stream_id,
    vcs.sort_order,
    vcs.title,
    vcs.data_url,
    vcs.iframe_url,
    ps.name_of_stream,
    ps.page_id
   FROM ( SELECT vc_streams.datacast_identifier,
            vc_streams.view_cast_id,
            vc_streams.data_json,
            vc_streams.template_card_id,
            vc_streams.s3_identifier,
            vc_streams.seo_blockquote,
            vc_streams.stream_id,
            vc_streams.sort_order,
            vc_streams.data_url,
            vc_streams.iframe_url,
            s.title
           FROM ( SELECT vc.datacast_identifier,
                    vc.id AS view_cast_id,
                    vc.data_json,
                    vc.template_card_id,
                    tc.s3_identifier,
                    vc.seo_blockquote,
                    se.stream_id,
                    se.sort_order,
                    concat(s.cdn_endpoint,'/',vc.datacast_identifier,'/data.json') as data_url,
                    concat('https://utils.pro.to', '/', tc.s3_identifier, '/index.html?view_cast_id=', vc.datacast_identifier, '&base_url=', s.cdn_endpoint) as iframe_url
                   FROM view_casts vc
                     LEFT JOIN sites s ON vc.site_id = s.id
                     LEFT JOIN template_cards tc ON vc.template_card_id = tc.id
                     LEFT JOIN stream_entities se ON se.entity_value::integer = vc.id AND se.entity_type::text = 'view_cast_id'::text
                  WHERE vc.data_json IS NOT NULL
                  ORDER BY se.stream_id, se.sort_order) vc_streams
             JOIN streams s ON s.id = vc_streams.stream_id) vcs
     LEFT JOIN page_streams ps ON vcs.stream_id = ps.stream_id
  ORDER BY vcs.stream_id, vcs.sort_order;")
  end
end
