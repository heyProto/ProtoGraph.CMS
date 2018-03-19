namespace :permissions do
    task migrate: :environment do
        User.all.each do |u|
            u.permissions.update_all(name: u.name, bio: u.bio, meta_description: u.bio)
        end
    end
end