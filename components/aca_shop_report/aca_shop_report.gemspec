$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "aca_shop_report/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "aca_shop_report"
  s.version     = AcaShopReport::VERSION
  s.authors     = ["Dan Thomas"]
  s.email       = ["dan@ideacrew.com"]
  s.homepage    = "https://github.com/dchbx"
  s.summary     = %q{ACA SHOP employer-sponsered health and dental benefit reporting}
  s.description = %q{An Enroll App extension that supports reporting for the ACA Small Business Health Options Program (SHOP) Marketplace}
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.2.3"
  s.add_dependency "slim", "3.0.8" 
  s.add_dependency "mongoid", "~> 5.0.1"

  s.add_development_dependency "rspec-rails" 
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
end
