namespace :permissions do
    task migrate: :environment do
        User.all.each do |u|
            u.permissions.update_all(name: u.name, bio: u.bio, meta_description: u.bio)
        end
    end
    
    
    task rename_recycle_bin: :environment do
        Folder.where(is_trash: true).update_all(name: "Trash")
    end
end