namespace :hidden_pykih_user do
  desc "Adds a hidden pykih user in all user accounts"
  task :add => :environment do
    pykih_admins = {}
    User.where(email: ["ritvvij.parrikh@pykih.com", "ab@pykih.com", "dhara.shah@pykih.com"]).each do |user|
      pykih_admins[user.email] = user
    end

    Account.all.each do |account|
      account_users = account.users.pluck(:email)
      pykih_admins.each do |email, user|
        user.create_permission("Account", account.id, "owner",true)
      end
    end
  end
end
