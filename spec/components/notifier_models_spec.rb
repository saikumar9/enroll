require 'rails_helper'

Dir[Rails.root.join("components/notifier/spec/models/notifier/*_spec.rb")].each do |f|
  require f
end