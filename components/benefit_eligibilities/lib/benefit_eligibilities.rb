require "benefit_eligibilities/engine"
require "active_model"
require "nokogiri"

module BenefitEligibilities

  def options
    self.class.options
  end

  def self.options
    begin
      @@options ||= {
        :state_config => JSON.parse!(File.read(Rails.root.join('config/state_config.json'))),
        :system_config => JSON.parse!(File.read(Rails.root.join('config/system_config.json'))),
        :ineligibility_reasons => YAML.load_file(Rails.root.join('config/code_explanation.yml'))
      }.with_indifferent_access
    rescue JSON::ParserError
      raise JSON::ParserError, "failed to parse config file"
    end
  end


end
