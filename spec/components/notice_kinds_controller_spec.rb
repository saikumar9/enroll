require 'rails_helper'

Dir[Rails.root.join("components/notifier/spec/controllers/*_spec.rb")].each do |f|
  require f
end
