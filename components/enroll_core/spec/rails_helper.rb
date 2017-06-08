# This file is copied to spec/ when you run 'rails generate rspec:install'

ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../dummy/config/environment.rb", __FILE__)

require 'rspec/rails'
require 'spec_helper'
require 'factory_girl_rails'

require 'mongoid-rspec'
require 'capybara/rspec'
require 'pundit/rspec'
require 'database_cleaner'

require 'support/factory_girl'
require 'shoulda/matchers'

Rails.backtrace_cleaner.remove_silencers!

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
  end
end
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
Dir[EnrollCore::Engine.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs

  config.disable_monkey_patching!
  config.include Mongoid::Matchers, type: :model

  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false

  config.warnings = false
  config.profile_examples = nil 
  config.order = :random 
  Kernel.srand config.seed


  config.after(:example, :dbclean => :after_each) do
    DatabaseCleaner.clean
    TimeKeeper.set_date_of_record_unprotected!(Date.current)
  end

  config.around(:example, :dbclean => :around_each) do |example|
    DatabaseCleaner.clean
    example.run
    DatabaseCleaner.clean
    TimeKeeper.set_date_of_record_unprotected!(Date.current)
  end

  # config.include ModelMatcherHelpers, :type => :model
  # config.include Devise::TestHelpers, :type => :controller
  # config.include Devise::TestHelpers, :type => :view
  # config.extend ControllerMacros, :type => :controller #real logins for integration testing
  # config.include ControllerHelpers, :type => :controller #stubbed logins for unit testing

  # config.infer_spec_type_from_file_location!
  config.include Capybara::DSL

end

# These are included here because map/reduce flips out if the collections don't exist
# This interacts strangely with db cleaner in some circumstances (i.e. multiple dbs)
# Person.create_indexes
# Family.create_indexes
