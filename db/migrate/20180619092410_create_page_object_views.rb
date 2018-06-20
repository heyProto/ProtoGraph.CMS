class CreatePageObjectViews < ActiveRecord::Migration[5.1]
  def change
    execute("CREATE OR REPLACE VIEW page_objects AS
        select  vcs.*, ps.name_of_stream, ps.page_id from (select vc_streams.*, s.title from (select
            vc.datacast_identifier, vc.id as view_cast_id, vc.data_json, vc.template_card_id, vc.seo_blockquote, se.stream_id, se.sort_order
        from
            view_casts vc inner join stream_entities se
        on
            se.entity_value::integer = vc.id and se.entity_type='view_cast_id'
        where
            vc.data_json IS NOT NULL
        order by
            se.stream_id, se.sort_order) as vc_streams join streams s on s.id = vc_streams.stream_id) as vcs left join page_streams ps on vcs.stream_id = ps.stream_id order by stream_id, sort_order;")
  end
end
