namespace :auto_streams do
    task create: :environment do
        puts "Creating Site Streams"
        Site.all.each do |site|
            if site.stream.blank?
                user_id = site.account.users.first.id
                stream = Stream.create!({
                    is_automated_stream: true,
                    col_name: "Site",
                    col_id: site.id,
                    updated_by: user_id,
                    created_by: user_id,
                    account_id: site.account_id,
                    site_id: site.id,
                    title: site.name,
                    description: "#{site.name} site stream",
                    limit: 50
                })

                site.update_columns(stream_url: "#{site.cdn_endpoint}/#{stream.cdn_key}", stream_id: stream.id)
            else
                stream = site.stream
            end
            stream.publish_cards
            stream.publish_rss
            site.permissions.each do |permission|
                if permission.stream.blank?
                    s = Stream.create!({
                        is_automated_stream: true,
                        col_name: "Permission",
                        col_id: permission.id,
                        account_id: site.account_id,
                        site_id: site.id,
                        title: "#{permission.username}",
                        description: "#{permission.username} stream",
                        limit: 50
                    })
                    permission.update_columns(stream_url: "#{s.site.cdn_endpoint}/#{s.cdn_key}", stream_id: s.id)
                else
                    s = permission.stream
                end
                s.publish_cards
                s.publish_rss
            end
        end

        RefCategory.all.each do |ref|
            if ref.stream.blank?
                s = Stream.create!({
                    is_automated_stream: true,
                    col_name: "RefCategory",
                    col_id: ref.id,
                    account_id: ref.site.account_id,
                    title: ref.name,
                    description: "#{ref.name} stream",
                    site_id: ref.site_id,
                    limit: 50
                })

                ref.update_columns(stream_url: "#{s.site.cdn_endpoint}/#{s.cdn_key}", stream_id: s.id)
            else
                s = ref.stream
            end
            s.publish_cards
            s.publish_rss
        end

    end
end