namespace :ceew_districsts do
    task load: :environment do
        ceew_account = Rails.env.development? ? Account.friendly.find('pykih') : Account.friendly.find('ceew')
        ceew_site = ceew_account.site
        current_user = User.find(2)
        # Create all the pages

    end
end