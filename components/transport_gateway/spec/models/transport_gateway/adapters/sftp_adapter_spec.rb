require 'rails_helper'

module TransportGateway
  RSpec.describe Adapters::SftpAdapter, type: :model do
    let(:adapter)       { Adapters::SftpAdapter.new }

    let(:source_host)   { "localhost"}
    let(:source_folder) { File.join(File.expand_path("../../../..", __FILE__), "test_files") }
    let(:source_file)   { "text_file.txt" }
    let(:source_path)   { File.join(source_folder, source_file) }
    let(:from)          { URI::FTP.build({ host: source_host, path: source_path }) } 
    let(:body)          { nil }

    context "Upload files to SFTP server" do
      let(:target_host)   { "ftp.example.com" }
      let(:target_folder) { "/path/to/target/folder" }
      let(:target_path)   { File.join(target_folder, source_file) }

      context "#send_message" do
        let(:userinfo)  { "foo:bar" }
        let(:from)      { URI::FTP.build({ host: source_host, path: source_path }) } 
        let(:to)        { URI::FTP.build({ host: target_host, path: target_path, userinfo: userinfo }) }
        let(:body)      { nil }

        let(:valid_params) do
          {
            from: from,
            to: to,
            body: body
          }
        end

        context "with no arguments" do
          let(:params)  {{}}
          let(:message) { Message.new(**params)}

          it "should raise an Argument error" do
            expect{ Adapters::SftpAdapter.new.send_message(message) }.to raise_error(ArgumentError, /source file not provided/) 
          end
        end

        context "with no source file (message.from)" do
          let(:params)  { valid_params.except(:from) }
          let(:message) { Message.new(**params)}

          it "should raise an Argument error" do
            expect{ Adapters::SftpAdapter.new.send_message(message) }.to raise_error(ArgumentError, /source file not provided/) 
          end
        end

        context "with no target file (message.to)" do
          let(:params)  { valid_params.except(:to) }
          let(:message) { Message.new(**params)}

          it "should raise an Argument error" do
            expect{ Adapters::SftpAdapter.new.send_message(message) }.to raise_error(ArgumentError, /target file not provided/) 
          end
        end
      end

      context "and target server username:password is nil" do
        let(:to)        { URI::FTP.build({ host: target_host, path: target_path }) } 
        let(:message)   { Message.new(from: from, to: to) }

        it "should raise an error" do
          expect{ Adapters::SftpAdapter.new.send_message(message) }.to raise_error(ArgumentError, /target server username:password not provided/ ) 
        end
      end

      context "and target server Username/Password is invalid" do
        let(:target_user)       { "foo" }
        let(:expired_password)  { "expired_password" }
        let(:userinfo)          { target_user + ':' + expired_password }
        let(:to)        { URI::FTP.build({ host: target_host, path: target_path, userinfo: userinfo }) }

        it "should fail to authenticate"

        context "and target Username/Password is valid" do
          let(:target_user)       { "foo" }
          let(:target_password)   { "super_secret" }
          let(:userinfo)          { target_user + ':' + target_password }
          let(:to)        { URI::FTP.build({ host: target_host, path: target_path, userinfo: userinfo }) }

          it "should authenticate"

          context "and target path isn't found" do
            it "should create target path"

            it "should upload the file"
          end

          context "and target path is found" do
            let(:message)     { Message.new(from: from, to: to) }

            it "should upload the file" do
              # adapter.send_message(message)

              # Mock the FTP server
            end
          end

        end
      end

    end

    context "send a list of files to SFTP server" do
      let(:message1)  { Message.new() }
      let(:message2)  { Message.new() }
      let(:messages)  { [message1, message2] }

      context "and files are targeted for the same remote server" do
        it "should group files by server and transmit asynchronously"

      end

      context "and files are targeted for different remote servers" do
        it "should error out"
      end
    end

  end
end
