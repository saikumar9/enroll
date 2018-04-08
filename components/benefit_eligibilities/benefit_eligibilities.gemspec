$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "benefit_eligibilities/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "benefit_eligibilities"
  s.version     = BenefitEligibilities::VERSION
  s.authors     = ["Dan Thomas"]
  s.email       = ["dan@ideacrew.com"]
  s.homepage    = "https://github.com/dchbx"
  s.summary     = "A Medicaid eligibility rules engine that makes determinations using an applicant household's " + \
                  "Modified Adjusted Gross Income (MAGI) and other eligibility criteria"
  s.description = "Rails engine implementation of HHSIDEAlab's medicaid_eligibility project: " + \
                  "https://github.com/HHSIDEAlab/medicaid_eligibility  Copyright (c) 2013, BlueLabs LLC.  All rights reserved"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.2.7.1"

  s.add_dependency 'activerecord-nulldb-adapter'
  s.add_dependency "active_model_serializers", '~> 0.10.0'
  s.add_dependency 'nokogiri'

  # s.add_dependency "gon"
  # s.add_dependency "httparty"
  # s.add_dependency 'ci_reporter_rspec'
  # s.add_dependency "rails_12factor"

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails', '4.6.0'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'pry-rails'
  s.add_development_dependency 'pry-stack_explorer'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'pry-remote'
  s.add_development_dependency 'forgery'
end
