namespace :hidden_pykih_user do
  desc "Adds a hidden pykih user in all user accounts"
  task :add => :environment do
    pykih_admins = ["ritvvij.parrikh@pykih.com", "rp@pykih.com", "ab@pykih.com", "dhara.shah@pykih.com", "aashutosh.bhatt@pykih.com"]

    pykih_admin = User.find_by(email: "ab@pykih.com")

    User.where.not(email: pykih_admins).each do |u|
      u.accounts.each do |a|
        p = Permission.create(
          is_hidden: true,
          created_by: pykih_admin.id,
          updated_by: pykih_admin.id,
          account_id: a.id,
          user_id: pykih_admin.id,
          ref_role_slug: "owner"
        )
      end
    end
  end
end
