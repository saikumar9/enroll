$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "transport_gateway/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "transport_gateway"
  s.version     = TransportGateway::VERSION
  s.authors     = ["Dan Thomas"]
  s.email       = ["dan@ideacrew.com"]
  s.homepage    = "https://github.com/dchbx"
  s.summary     = %q{A gateway for receiving and forwarding messages over various protocols}
  s.description = %q{A gateway that abstracts and transmits message payloads over SMTP, SFTP, HTTP, file and other protocols}
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.3"
  s.add_dependency "slim", "3.0.8" 
  s.add_dependency "mongoid", "~> 5.0.1"

  s.add_development_dependency "rspec-rails" 
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
end
