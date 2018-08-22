namespace :footer do
    task load: :environment do
        Page.all.each do |a|
            puts a.id
            puts "============="
            name = a.template_page.name == 'article' ? "Story_Footer" : "Section_footer"
            stream = Stream.create!({
                col_name: "Page",
                col_id: a.id,
                site_id: a.site_id,
                folder_id: a.folder_id,
                created_by: a.created_by,
                updated_by: a.updated_by,
                title: "#{a.id}_#{name}",
                description: "#{a.id}-#{name} stream #{a.summary}"
            })

            page_stream = PageStream.create!({
                page_id: a.id,
                stream_id: stream.id,
                name_of_stream: "Footer",
                created_by: a.created_by,
                updated_by: a.updated_by
            })
        end
    end
end