require 'rails_helper'

module TransportGateway
  RSpec.describe Adapters::SftpAdapter, type: :model do
    let(:host)              { "sftp://sftp.example.com/" }
    let(:user)              { "foo" }
    let(:password)          { "bar" }
    let(:remote_file_path)  { "path/to/folder" }
    let(:local_file1_path)  { File.join(File.expand_path("../../../support", __FILE__), "test_files", "binary_mhc_logo.png") }
    let(:local_file2_path)  { File.join(File.expand_path("../../../support", __FILE__), "test_files", "text_file.txt") }
    let(:adapter)           { Adapters::SftpAdapter.new }

    let(:remote_file_path)  { "sftp://foo:bar@sftp.example.com/path/to/folder" }

    context "send a single file synchronous to SFTP server" do
      let(:remote_file_path)  { "path/to/remote/folder" }
      let(:message)   { Message.new(file_path, to, binary_file) }
      let!(:response) { adapter.send_message(message) }

      it "should upload a file to the server" do
        expect(WebMock).to have_requested(:upload, url).once
      end

      it "should post return a success result" do
        expect(response).to be_kind_of Net::HTTPSuccess
      end
    end

    context "send a list of files to SFTP server" do
      let()
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
