source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.7.1'

# Mount Enroll App component engines
gem "transport_gateway",  path: "components/transport_gateway"
gem "notifier",           path: "components/notifier"
gem "transport_profiles", path: "components/transport_profiles"
gem "sponsored_benefits", path: "components/sponsored_benefits"
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '4.0.5'
gem 'jquery-ui-rails'
gem 'animate-rails', '~> 1.0.7'
gem 'maskedinput-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'jquery-turbolinks'
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# JS graph API
# gem 'highcharts-rails', '~> 4.1', '>= 4.1.9'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'less-rails-bootstrap', '~> 3.3.1.0'
gem 'font-awesome-rails', '4.5.0.1'
gem 'nokogiri-happymapper', :require => 'happymapper'
gem 'nokogiri', '1.6.7.2'

gem 'mongo', '2.1.2'
gem 'mongoid', '5.0.1'
gem 'mongoid-history', git: "https://github.com/aq1018/mongoid-history.git", branch: "master"
# gem 'mongoid-history', '~> 5.1.0'
gem 'mongoid_userstamp'
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem "mongoid-autoinc"
gem 'mongoid-versioning'
gem 'money-rails', '~> 1.3.0'
gem "mongoid-enum"
gem 'mongo_session_store-rails4', '~> 6.0.0'

## Add field-level encryption
# gem 'mongoid-encrypted-fields', '~> 1.3.3'
gem 'symmetric-encryption', '~> 3.6.0'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1'

gem 'acapi', git: "https://github.com/dchbx/acapi.git", branch: 'development'
# gem 'acapi', path: "../acapi"
gem 'openhbx_cv2', git: "https://github.com/dchbx/openhbx_cv2.git", branch: 'master'

#For Background jobs
gem 'resque'

gem 'aasm', '~> 4.8.0'
gem 'haml'
# gem 'bh'

# spreadsheet support
gem 'roo', '~> 2.1.0'

# configuration support
gem "config", '~> 1.0.0'

gem 'devise', '>= 3.5.4'
# gem 'devise_ldap_authenticatable', '~> 0.8.1'
gem "pundit", '~> 1.0.1'

# will provide fast group premium plan fetch
gem 'redis-rails'

gem 'kaminari'

gem 'sprockets' , "~> 2.12.3"
# for I18n
gem 'rails-i18n', '4.0.8'
gem 'mail', '2.6.3'
gem 'bson', '3.2.6'
gem 'addressable', '2.3.8'
# gem 'rypt', '0.2.0'

gem 'language_list', '~> 1.1.0'
gem 'bootstrap-multiselect-rails', '~> 0.9.9'
gem 'bootstrap-slider-rails', '6.0.17'

gem 'prawn', :git => "https://github.com/prawnpdf/prawn.git", :ref => '8028ca0cd2'
gem 'virtus'
gem 'wkhtmltopdf-binary-edge', '~> 0.12.3.0'
gem 'wicked_pdf', '1.0.6'

# provide recaptcha services
gem "recaptcha", '4.3.1', require: 'recaptcha/rails'

# gem 'jquery-datatables-rails', '3.4.0'
gem 'jquery-datatables-rails', '3.3.0'
gem 'effective_datatables', path: './project_gems/effective_datatables-2.6.14'

gem 'interactor', '3.1.0'
gem 'interactor-rails', '2.0.2'
gem 'chosen-rails'

# gem 'rocketjob_mission_control', '~> 3.0'
# gem 'rails_semantic_logger'
# gem 'rocketjob', '~> 3.0'

gem 'ckeditor'
gem 'redcarpet', '3.4.0'
gem 'slim', '3.0.8'
gem 'curl'
gem 'non-stupid-digest-assets', '~> 1.0', '>= 1.0.9'

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '2.3.0'
  gem "certified"
end

group :development, :test do
  # YARD documentation generation tool: http://yardoc.org/
  gem 'yard', '~> 0.9.5'
  gem 'yard-mongoid', '~> 0.1.0'
  gem 'railroady', '~> 1.5.2'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-stack_explorer'
  gem 'pry-byebug'
  gem 'pry-remote'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '1.6.3'

  # Use Capistrano for deployment
  gem 'capistrano', '3.3.5'
  # gem 'capistrano-scm-gitcopy'
  gem 'capistrano-rails', '1.1.6'
  gem 'ruby-progressbar', '1.6.0'

  # Keep these in Development and Test environments for access by rails generators
  gem 'rspec-rails', '~> 3.4.2'
  gem 'email_spec', '2.0.0'
  gem 'byebug', '8.2.2'
  gem 'rspec_junit_formatter', '0.2.3'
  gem "parallel_tests"

  gem 'puma'
end

group :test do
  gem 'simplecov', '0.14.1', :require => false
  gem 'mongoid-rspec', '3.0.0'
  gem 'watir'
  gem 'webmock'
  gem 'cucumber-rails', '~> 1.4.2', :require => false
  gem 'poltergeist'
  gem 'capybara-screenshot'
  gem 'database_cleaner', '1.5.3'
  gem 'shoulda-matchers', '3.1.1'
  gem 'action_mailer_cache_delivery', '~> 0.3.7'
  gem 'capybara', '2.6.2'
  gem 'warden'
  gem 'fakeredis', :require => 'fakeredis/rspec'
  gem 'rspec-instafail'
end

group :production do
  # Use Unicorn as the app server
  gem 'unicorn', '~> 4.8.3'
  gem 'eye', '0.8.0'

  # New Relic gem
  gem 'newrelic_rpm'

end

gem 'aws-sdk', '2.2.4'
gem 'ruby-saml', '~> 1.3.0'
gem 'combine_pdf'
gem 'recurring_select', :git => 'https://github.com/brianweiner/recurring_select'
gem 'simple_calendar', :git => 'https://github.com/harshared/simple_calendar'
gem 'factory_girl_rails', "4.6.0"
gem 'forgery'
