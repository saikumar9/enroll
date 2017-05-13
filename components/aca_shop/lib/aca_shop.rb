require "aca/shop/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "rails/test_unit/railtie"
require "sprockets/railtie" # Uncomment this line for Rails 3.1+

# Configure fallbacks for mongoid errors:
require "i18n/backend/fallbacks"

require "jquery-rails"

# require "aca-individual"

require File.expand_path("../monkey_patches/engine.rb", __FILE__)

module Aca
  module Shop
  end
end
