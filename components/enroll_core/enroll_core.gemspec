$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "enroll_core/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "enroll_core"
  s.version     = EnrollCore::VERSION
  s.authors     = ["Dan Thomas"]
  s.email       = ["dan.thomas@dc.gov"]
  s.description   = %q{Enroll App shared domain logic}
  s.summary       = "Benefits enrollment gem"
  s.homepage      = "https://github.com/dchbx"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]
  s.metadata["yard.run"] = "yri" # use "yard" to build full HTML docs.

  s.add_dependency "rails", "~> 5.1.1"
  s.add_dependency "rails-i18n", "~> 5.0.0"

  s.add_dependency "mongoid", "6.1.0"
  s.add_dependency "pundit", "~> 1.1.0"
  s.add_dependency "symmetric-encryption", "~> 3.9.0"
  s.add_dependency "aasm", "~> 4.12.0"

  s.add_dependency "money-rails"
  s.add_dependency "config"
  s.add_dependency "devise"
  # s.add_dependency "mongoid-versioning"

  s.add_development_dependency "spring"
  s.add_development_dependency "spring-commands-rspec"
  s.add_development_dependency "spring-commands-cucumber"

  s.add_development_dependency "byebug"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "mongoid-rspec"
  s.add_development_dependency "shoulda-matchers"

  s.add_development_dependency "database_cleaner"

  s.add_development_dependency "pundit-matchers"
  s.add_development_dependency "factory_girl_rails"

  s.add_development_dependency "poltergeist"

###

  # s.add_dependency "jquery-rails", "4.0.5"
  # s.add_development_dependency "capybara"
  # s.add_dependency "sass-rails", "5.0.4"



end
