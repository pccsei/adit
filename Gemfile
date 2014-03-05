# `bundle install --without production` will avoid
# installing gems from the production group
# That setting will be saved so you can run just 
# `bundle install` in the future

source 'http://rubygems.org'

ruby '1.9.3'
gem 'rails',        '4.0.0'
gem 'mysql2',       '0.3.11'   # For both dev and production side
gem 'net-ldap',     '0.3.1'    # For Active Directory support? -Rob
gem 'sass-rails',   '~> 4.0.0' # SASS for stylesheets
gem 'uglifier',     '>= 1.3.0' # Compressor for JavaScript assets
gem 'coffee-rails', '~> 4.0.0' # CoffeeScript for .js.coffee assets and views
gem 'turbolinks'               # Makes following links faster
                               # Read more: https://github.com/rails/turbolinks
gem 'jbuilder',     '~> 1.2'   # Build JSON APIs with ease. 
                               # Read more: https://github.com/rails/jbuilder
gem 'jquery-validation-rails'  # Validating form input (Added by Jake Canipe)
gem 'jquery-ui-rails'
gem 'jquery-rails'
gem 'jquery-datatables-rails'
gem 'will_paginate'
gem 'bootstrap-sass', '~> 3.0.2.0'
gem 'figaro'
gem 'high_voltage', '~> 2.0.0'
gem 'thin'
gem 'ffi', '~> 1.9.3'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :mri_20, :rbx]
  gem 'guard-bundler', ' ~> 2.0.0 '
  gem 'guard-rails'
  gem 'rails_layout'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
end

group :test do
  gem 'selenium-webdriver'
  gem 'database_cleaner'
end

group :production do
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', platforms: :ruby
end
