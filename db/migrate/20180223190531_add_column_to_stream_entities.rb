class AddColumnToStreamEntities < ActiveRecord::Migration[5.1]
  def change
    add_column :stream_entities, :sort_order, :integer

    all_pages = Page.where(template_page_id: TemplatePage.where(name: ['Homepage: Vertical', 'article']).pluck(:id))
    all_pages.each do |page|
        page.streams.each do |stream|
            site = stream.site
            begin
                data = JSON.parse(RestClient.get("#{site.cdn_endpoint}/#{stream.cdn_key}").body)
                s_order = 1
                data.each do |d|
                    view_cast = ViewCast.find_by_datacast_identifier(d['view_cast_id'])
                    if view_cast.present?
                        s = stream.view_cast_ids.where(entity_value: view_cast.id).first
                        s.update_column(:sort_order, s_order) if s.present?
                        s_order += 1
                    end
                end
                stream.update_attributes(include_data: false)
                stream.publish_cards
            rescue => e
            end
        end
    end
  end
end
