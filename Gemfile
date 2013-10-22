source 'https://rubygems.org'

gem 'rails', '3.2.5'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# database gem
gem 'mysql2'
gem "redis" , "~> 3.0.0"

# pagination
gem 'kaminari', "~> 0.13.0"

# devise
gem 'devise', "~> 2.1.3"

gem 'mechanize', "~> 2.5.1"

gem 'differ', '~> 0.1.2'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'twitter-bootstrap-rails', '~> 2.1.0'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', "~> 0.10.1", :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'
gem 'capistrano-ext'

# Resque for offline processing and foreman to manage processes
gem 'resque', '~> 1.21.0'
gem 'foreman', '~> 0.51.0'

# To use debugger
# gem 'debugger'

gem 'ace-rails-ap'
gem 'json', '~> 1.7.7'

group :development, :test do
  gem "rspec-rails", "~> 2.8.0"
  gem "rspec", "~> 2.8.0"
  gem "database_cleaner"
  gem "capybara", "~> 1.1.2"
  gem 'simplecov', "~> 0.6.4", :require => false
  gem 'ZenTest', "~> 4.8.1"
  gem 'autotest-growl', '~> 0.2.16'
  gem 'autotest-rails-pure', '~> 4.1.2'
  gem "cucumber", "~> 1.2.1"
  gem "cucumber-rails", "~> 1.3.0", :require => false
  gem "capybara-webkit", "~> 0.12.1"
  gem "pry-rails", "~> 0.1.6"
  gem 'thin', '~> 1.4.1'
end

group :test do
  gem 'factory_girl', '~> 3.4.0'
  gem "factory_girl_rails"
  gem "webmock", '~> 1.8.7'
  gem 'resque_spec', '~> 0.12.2'
  gem 'timecop', '~> 0.3.5'
end
