# `bundle install --without production` will avoid
# installing gems from the production group
# That setting will be saved so you can run just 
# `bundle install` in the future

# All gems have been at least loosely versioned so 
# that an unexpected update doesn't break anything
# in the last month of development. Run the command
# `bundle outdated` to see which gems could be updated
# and test on your system before changing the version
# number here.

source 'http://rubygems.org'

ruby '1.9.3'
gem 'rails',                   '4.0.0'

gem 'bootstrap-sass',          '~> 3.0.2.0' # Styling presets
gem 'bourbon',                 '~> 3.1.8'   # Lightweight library of SASS mixins
gem 'coffee-rails',            '~> 4.0.0'   # CoffeeScript for .js.coffee assets and views
gem 'ffi',                     '~> 1.9.3'
gem 'figaro',                  '~> 0.7.0'
gem 'high_voltage',            '~> 2.0.0'
gem 'jbuilder',                '~> 1.2'     # Build JSON APIs with ease. 
gem 'jquery-datatables-rails', '~> 1.12.2'
gem 'jquery-rails',            '~> 3.1.0'
gem 'jquery-ui-rails',         '~> 4.2.0'
gem 'jquery-validation-rails', '~> 1.11.1'  # Validating form input (Added by Jake Canipe)
gem 'mysql2',                  '0.3.11'     # For both dev and production side
gem 'net-ldap',                '0.3.1'      # For Active Directory support? -Rob
gem 'sass-rails',              '~> 4.0.0'   # SASS for stylesheets (.css.scss)
gem 'thin',                    '~> 1.6.2'   # Rails server
gem 'turbolinks',              '~> 2.2.1'   # Makes following links faster
gem 'uglifier',                '>= 1.3.0'   # Compressor for JavaScript assets
gem 'will_paginate',           '~> 3.0.5'
gem 'paper_trail'

group :development do
  gem 'better_errors',         '~> 1.1.0'
  gem 'binding_of_caller',     '~> 0.7.2',  :platforms=>[:mri_19, :mri_20, :rbx]
  gem 'guard-bundler',         '~> 2.0.0'
  gem 'guard-rails',           '~> 0.5.0'
  gem 'rails_layout',          '~> 1.0.10'
  gem 'rb-fchange',            '~> 0.0.6',  :require=>false
  gem 'rb-fsevent',            '~> 0.9.4',  :require=>false
  gem 'rb-inotify',            '~> 0.9.3',  :require=>false
end

group :test do
  gem 'selenium-webdriver',    '~> 2.40.0'
  gem 'database_cleaner',      '~> 1.2.0'
end

group :production do
  gem 'therubyracer',          '~> 0.12.1', platforms: :ruby
end
