# workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count
preload_app!
root_dir = File.expand_path("../../",__FILE__)
rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RAILS_ENV'] || 'development'
bind "unix://#{root_dir}/tmp/sockets/puma.sock"
# stdout_redirect "#{root_dir}/log/puma.stdout.log", "#{root_dir}/log/puma.stderr.log", true
on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end