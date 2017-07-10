require 'rails_helper'
require 'net/http'

module TransportGateway
  RSpec.describe Gateway, type: :model do

    let(:sftp_uri)      { URI("sftp://foo:bar@sftp.example.com/path/to/file;type=b") } 
    let(:binary_file)   {  }

    context "sends messages and payloads over various protocols using a common interface" do

      context "when a TransportGateway is initialized" do
        # let(:gateway)   { TransportGateway::TransportGateway.new() }

        it "should load an SFTP adapter" do
          expect(Gateway.new().adapters).to include(:sftp_adapter)
        end

        it "should load an HTTP adapter" do
          expect(Gateway.new().adapters).to include(:http_adapter)
        end

        it "should load an File adapter" do
          expect(Gateway.new().adapters).to include(:file_adapter)
        end

        it "should load an AWS S3 adapter" do
          expect(Gateway.new().adapters).to include(:s3_adapter)
        end


        context "and a file-type source is specified" do
          let(:source_file_path)    { File.join(File.expand_path("../../..", __FILE__), "test_files", "text_file.txt") }
          let(:source_file_handle)  { File.new(source_file_path) }
          let(:source_file_data)    { File.read(source_file_path) }

          it "should find the test file with the expected contents" do
            expect(File.read(source_file_path)).to eq source_file_data
          end

          context "and a message is sent using SFTP protocol" do
            let(:target_host)     { "ftp.example.com" }
            let(:target_folder)   { "/path/to/target/folder" }
            let(:target_user)     { "foo" }
            let(:target_password) { "secret_password" }
            let(:target_userinfo) { target_user + ':' + target_password }
            let(:scheme)          { "sftp"}

            let(:from)            { source_file_handle }
            let(:to)              { URI::Generic.build({ scheme: scheme, host: target_host, path: target_folder, userinfo: target_userinfo }) } 
            let(:message)         { Message.new(from: from, to: to) }

            it "should successfully send the file" do
              expect(Gateway.new().send_message(message)).to eq "worked!"
            end

          end

          context "and a message is sent using HTTP protocol" do
            let(:target_host)       { "www.example.com" }
            let(:target_service)    { "/path/to/target/service" }
            let(:target_user)       { "foo" }
            let(:target_password)   { "secret_password" }
            let(:target_userinfo)   { target_user + ':' + target_password }
            let(:scheme)            { "http"}

            let(:from)              { source_file_handle }
            let(:to)                { URI::Generic.build({ scheme: scheme, host: target_host, path: target_service, userinfo: target_userinfo }) } 
            let(:message)           { Message.new(from: from, to: to) }

            it "should successfully send the file, returning a HTTP success status" do
              expect(Gateway.new().send_message(message)).to be_kind_of Net::HTTPSuccess
            end

          end

          context "and a message is sent using SMTP protocol" do
          end

          context "and a message is sent using File protocol" do
          end

          context "and a message is sent using S3 protocol" do
          end

          context "and a message is sent with unsupported protocol" do
            it "should raise an error"
          end
        end
      end

      #     let(:userinfo)  { "foo:bar" }
      #     let(:from)      { URI::FTP.build({ host: source_host, path: source_path }) } 
      #     let(:to)        { URI::FTP.build({ host: target_host, path: target_path, userinfo: userinfo }) }
      #     let(:body)      { nil }

      #     let(:valid_params) do
      #       {
      #         from: from,
      #         to: to,
      #         body: body
      #       }
      #     end

      #     context "with no arguments" do
      #       let(:params)  {{}}
      #       let(:message) { Message.new(**params)}

      #       it "should raise an Argument error" do
      #         expect{ Adapters::SftpAdapter.new.send_message(message) }.to raise_error(ArgumentError, /source file not provided/) 
      #       end
      #     end

      #     context "with no source file (message.from)" do
      #       let(:params)  { valid_params.except(:from) }
      #       let(:message) { Message.new(**params)}

      #       it "should raise an Argument error" do
      #         expect{ Adapters::SftpAdapter.new.send_message(message) }.to raise_error(ArgumentError, /source file not provided/) 
      #       end
      #     end
      # end

    end
  end
end
