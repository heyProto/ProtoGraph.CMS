namespace :user_email do
  desc 'Adds user_email for existing users.'
  task :seed  => :environment do
    User.all.each do |u|
      UserEmail.create(
        user_id: u.id,
        email: u.email,
        confirmed_at: Time.now,
        is_primary_email: 1
      )      
    end
  end
end
