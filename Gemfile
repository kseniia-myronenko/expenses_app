source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'
gem 'rails', '~> 7.0.3'

gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'devise', '~> 4.8', '>= 4.8.1'
gem 'pg', '~> 1.4', '>= 1.4.3'
gem 'psych', '< 4'
gem 'puma', '~> 4.1'
gem 'sass-rails', '>= 6'
gem 'simple_form', '~> 5.1'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 4.0'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'brakeman', '~> 5.2'
  gem 'bullet', '~> 7.0'
  gem 'bundler-audit', '~> 0.9.0'
  gem 'bundler-leak', '~> 0.3.0'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'ffaker', '~> 2.21'
  gem 'lefthook', '~> 0.7.7'
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
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'simplecov', '~> 0.21.2', require: false
  gem 'shoulda-matchers', '~> 5.1'
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
