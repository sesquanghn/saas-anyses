source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'rails', '~> 7.0.4'
# gem 'mysql2', '~> 0.5'
gem 'puma', '~> 5.0'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'bootsnap', require: false
gem 'rack-cors'

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'mysql2', '~> 0.5'
  gem 'pry'
end

group :development do
  gem 'annotate'
end

group :production do
  gem 'pg'
end

gem 'devise_token_auth'
gem 'aasm'
gem 'pagy', '~> 5.10'
gem 'jsonapi-serializer'
gem 'google-apis-oauth2_v2', require: false
gem 'pundit'
gem 'ransack'
gem 'slack-notifier', require: false
