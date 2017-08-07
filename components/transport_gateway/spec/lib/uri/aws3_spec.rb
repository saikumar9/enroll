require 'rails_helper'

module URI
  # RSpec.describe Aws3, type: :module do 
  RSpec.describe AWS3 do 

    context "Given an AWS3 URI" do
      # let(:uri)           { Class.new { include URI::AWS3 } }
      # let(:to)                { URI::Generic.build({ scheme: scheme, host: target_host, path: target_service, userinfo: target_userinfo }) } 

      let(:uri_string)    { "aws3:://region:site_abbrevation@bucket_name/object_collection/object" }
      let(:uri)           { URI.parse(uri_string) }
      let(:port_number)   { 443 }

      # let(:uri) { Class.new { include URI::AWS3 } }

      it "should initialize with the correct default port" do
        expect(AWS3.parse(uri_string).port).to eq port_number
      end

    end
  end
end