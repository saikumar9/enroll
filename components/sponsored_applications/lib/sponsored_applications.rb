require "sponsored_applications/engine"

require "mongoid"
require "mongoid_userstamp"
require "aasm"
require "config"
require "symmetric-encryption"

module SponsoredApplications
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  class Configuration
    attr_accessor :settings
  end
end
