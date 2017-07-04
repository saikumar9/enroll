require 'rails_helper'

module TransportGateway
  RSpec.describe TransportGateway, type: :model do

    let(:gateway)       { TransportGateway.new }
    let(:sftp_uri)      { URI("sftp://foo:bar@sftp.example.com/path/to/file;type=b") } 
    let(:message)       { Message.new }
    let(:binary_file)   {  }

    context ".new" do

      it "should load an SFTP adapter" do
        expect(gateway).to be_truthy
      end
    end


  end
end
