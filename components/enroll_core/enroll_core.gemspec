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

  s.add_dependency "rails", "~> 4.2.3"
  s.add_dependency "sass-rails", "5.0.4"
  s.add_dependency "jquery-rails", "4.0.5"

  s.add_dependency "mongoid", "5.0.1"
  s.add_dependency "pundit", "~> 1.1.0"
  s.add_dependency "symmetric-encryption", "~> 3.6.0"
  s.add_dependency "aasm", "~> 4.8.0"
  s.add_dependency "rails-i18n", "4.0.8"

  s.add_dependency 'acapi' #, git: "https://github.com/dchbx/acapi.git", branch: 'development'


  s.add_development_dependency "spring", "1.6.3"
  s.add_development_dependency "byebug"
  s.add_development_dependency "rspec-rails", "3.4.2"
  s.add_development_dependency "database_cleaner", "1.5.3"

  s.add_development_dependency "mongoid-rspec", "3.0.0"
  s.add_development_dependency "pundit-matchers","~> 1.2.3"

  s.add_development_dependency "factory_girl_rails", "4.6.0"
  s.add_development_dependency "capybara", "2.6.2"

  s.add_development_dependency "shoulda-matchers", "3.1.1"
  s.add_development_dependency "poltergeist", "1.11.0"
end
