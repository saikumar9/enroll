require 'rails_helper'
require 'net/http'

module TransportGateway
  RSpec.describe Adapters::HttpAdapter, type: :model do
    let(:from)      { "foo@bar.com" }
    let(:url)       { "http://www.example.com/path/to/resource" }
    let(:to)        { URI.parse(url) } 
    let(:adapter)   { Adapters::HttpAdapter.new }


    context "sending a text file to HTTP server endpoint" do
      let(:text_file) { File.join(File.expand_path("../../../support", __FILE__), "test_files", "text_file.txt") }
      let(:message)   { Message.new(from, to, text_file) }
      let!(:response) { adapter.send_message(message) }

      it "should post a text file to the server" do
        expect(WebMock).to have_requested(:put, url).once
      end

      it "should post return a success result" do
        expect(response).to be_kind_of Net::HTTPSuccess
      end

    end

    context "sending a binary file to HTTP server endpoint" do
      let(:binary_file) { File.join(File.expand_path("../../../support", __FILE__), "test_files", "binary_mhc_logo.png") }
      let(:message)   { Message.new(from, to, binary_file) }
      let!(:response) { adapter.send_message(message) }

      it "should post a binary file to the server" do
        expect(WebMock).to have_requested(:put, url).once
      end

      it "should post return a success result" do
        expect(response).to be_kind_of Net::HTTPSuccess
      end
    end

  end
end
