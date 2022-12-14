source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'
gem 'rails', '~> 7.0.3'

gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'bootstrap', '~> 5.2', '>= 5.2.1'
gem 'pg', '~> 1.4', '>= 1.4.3'
gem 'psych', '< 4'
gem 'puma', '~> 4.1'
gem 'rspec-rails', '~> 6.0.0.rc1'
gem 'sass-rails', '>= 6'
gem 'turbolinks', '~> 5'

group :development, :test do
  gem 'brakeman', '~> 5.2'
  gem 'bullet', '~> 7.0'
  gem 'bundler-audit', '~> 0.9.0'
  gem 'bundler-leak', '~> 0.3.0'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'ffaker', '~> 2.21'
  gem 'lefthook', '~> 0.7.7'
  gem 'pry-rails', '~> 0.3.9'
  gem 'rubocop', '~> 1.25'
  gem 'rubocop-performance', '~> 1.13'
  gem 'rubocop-rails', '~> 2.13'
  gem 'rubocop-rspec', '~> 2.8'
  gem 'traceroute', '~> 0.8.1'
end

group :development do
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.5'
  gem 'shoulda-matchers', '~> 5.1'
  gem 'simplecov', '~> 0.21.2', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
