# require 'ckeditor'

require "wkhtmltopdf-binary-edge"
require "wicked_pdf"
require "ckeditor"
require "mongoid"
require "devise"

module Notifier
  class Engine < ::Rails::Engine
    isolate_namespace Notifier

    # config.to_prepare do
    #   ApplicationController.helper(ActionView::Helpers::ApplicationHelper)
    # end

    # this might be able to move it to rails_helper.rb but need to understand engine path how it will works
    # initializer 'Notifier.factories', after: 'factory_girl.set_factory_paths' do
    #   factories_location = File.expand_path('../../../spec/factories', __FILE__)
    #   FactoryGirl.definition_file_paths.unshift(factories_location) if defined?(FactoryGirl)
    # end

    config.generators do |g|
      g.orm :mongoid 
      g.template_engine :slim
      g.test_framework :rspec, :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets true
      g.helper true 
    end
  end
end