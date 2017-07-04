require 'rails_helper'
require 'net/http'

module TransportGateway
  RSpec.describe Adapters::HttpAdapter, type: :model do
    let(:adapter)     { Adapters::HttpAdapter.new }
    let(:file_folder) { File.join(File.expand_path("../../../support", __FILE__), "test_files") }
    let(:binary_file) { File.join(file_folder, "binary_mhc_logo.png") }
    let(:text_string) { "madam in eden i'm adam" }

    # File.open('/tmp/response_body.txt', 'w') { |f| f.puts 'abc' }0
      # stub_request(:any, "www.example.com").
      #   to_return(body: File.new('/tmp/response_body.txt'), status: 200)

    context "Post content to HTTP server resource" do
      let(:from)  { "foo@bar.com" }
      let(:host)  { "www.example.com"}
      let(:path)  { "/path/to/resource" }
      let(:url)   { host + path }

      context "and the endpoint is available" do
        let(:to)          { URI::HTTP.build({ host: host, path: path }) } 
        let(:message)     { Message.new(from, to, text_string) }

        it "a Put request with text string to the URL should return a HTTP success status" do
          response = adapter.send_message(message)
          expect(response).to be_kind_of Net::HTTPSuccess
        end

        context "and request is sent without credentials" do
          let(:message)     { Message.new(from, to, text_string) }

          it "should post a file name to the server" do
            adapter.send_message(message)

            expect(WebMock).to have_requested(:put, url).
              with(body: text_string, headers: { content_type: 'text/plain'}).once
          end
        end

        context "and request is sent with Basic Authentication User and Password" do
          let(:user)          { "foo" }
          let(:password)      { "secret_password" }
          let(:userinfo)      { user + ':' + password }
          let(:to)            { URI::HTTP.build({ host: host, path: path, userinfo: userinfo }) } 
          let(:message)       { Message.new(from, to, text_string) }

          it "should post a file name to the server with credentials in header" do
            adapter.send_message(message)

            expect(WebMock).to have_requested(:put, url).
              with(basic_auth: [user, password], body: text_string, headers: { content_type: 'text/plain'}).once
          end
        end

      end

      context "using SSL" do
        # let(:cert_file)   { File.join(file_folder, "key.pem") }
        # http.use_ssl = true
        # http.cert = OpenSSL::X509::Certificate.new(pem)
        # http.key = OpenSSL::PKey::RSA.new(pem)
        # http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      end
    end


  end
end
