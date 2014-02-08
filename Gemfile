source 'http://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
ruby '1.9.3'
gem 'rails', '4.0.0'

# Use sqlite3 as the database for Active Record
gem 'mysql2', '0.3.11'
gem 'net-ldap', '0.3.1'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# Added by Jake Canipe
gem 'fancybox-rails'
gem 'jquery-validation-rails'

# added by James Miyashita
gem 'jquery-ui-rails'
gem 'jquery-rails'
gem 'jquery-datatables-rails', git: 'http://github.com/rweng/jquery-datatables-rails.git'

  # bundle exec rake doc:rails generates the API under doc/api.

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'bootstrap-sass', '~> 3.0.2.0'
gem 'figaro'
gem 'high_voltage', '~> 2.0.0'
gem 'simple_form', '>= 3.0.0.rc'
gem 'thin'
gem 'ffi', '~> 1.9.3'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :mri_20, :rbx]
  gem 'guard-bundler', ' ~> 2.0.0 '
  gem 'guard-rails'
  #gem 'quiet_assets', ' ~> 1.0.2 '
  gem 'rails_layout'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
end

group :test, :development do
  gem 'rspec-rails'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
end
