source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "2.3.3"

#RAILS
gem 'rails', '~> 5.1.1'
gem 'mysql2'
gem 'puma', '~> 3.7'

#CORE INFRASTRUCTURE
gem 'friendly_id', '~> 5.1.0'
gem 'dotenv'
gem 'dotenv-rails'
gem 'rest-client'
gem 'best_in_place', '~> 3.0.1'
gem 'kaminari'
gem "version"

#AUTHENTICATION
gem 'devise'
gem 'omniauth'
gem 'omniauth-instagram'
gem 'omniauth-facebook'
gem 'omniauth-twitter'

#VIEWS
gem 'simple_form', '~> 3.2', '>= 3.2.1'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'


group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem "annotate"
  gem "awesome_print"
  gem "rails-erd"
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]