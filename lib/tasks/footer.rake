namespace :footer do
    task load: :environment do
        Page.all.each do |a|
            streams.each do |s |
                stream = Stream.create!({
                    col_name: "Page",
                    col_id: a.id,
                    site_id: a.site_id,
                    folder_id: a.folder_id,
                    created_by: a.created_by,
                    updated_by: a.updated_by,a
                    title: "#{a.id}_#{s.first}",
                    description: "#{a.id}-#{s.first} stream #{a.summary}"
                })

                page_stream = PageStream.create!({
                    page_id: a.id,
                    stream_id: stream.id,
                    name_of_stream: s.last,
                    created_by: a.created_by,
                    updated_by: a.updated_by
                })
            end
        end
    end
end