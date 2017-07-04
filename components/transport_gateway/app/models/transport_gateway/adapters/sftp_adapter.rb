require 'net/ssh'
require 'net/sftp'

module TransportGateway
  class Adapters::SftpAdapter

    def initialize
      @user = ""
      @password = ""
    end


    def send_message(message)
      host              = message.to.host
      # port              = message.to.port || 22
      local_file_path   = message.from.path
      remote_file_path  = message.to.path

      if message.to.userinfo.present?
        parse_credentials(message.to.userinfo)
      else
        # This should check keystore based on host content
      end

binding.pry
      # response = Net::SFTP.new(host, port).start { |http| http.request(req) }
      response = Net::SFTP.start(host, @user, password: @password) do |sftp|
        sftp.upload!(local_file_path, remote_file_path) do |event, uploader, *args|
          send(event, uploader, *args) if respond_to?(event, true)
        end
      end
      response
    end


    # 
    def send_messages(messages)

      handle1 = sftp.open!("/path/to/file1")
      handle2 = sftp.open!("/path/to/file2")

      messages.each_with_object([]).with_index do |(message, memo), index|
        request[index]
      end

      r1 = sftp.read(handle1, 0, 1024)
      r2 = sftp.read(handle2, 0, 1024)

      sftp.loop { [r1, r2].any? { |r| r.pending? } }

      puts "chunk #1: #{r1.response[:data]}"
      puts "chunk #2: #{r2.response[:data]}"
    end

 private

  def parse_credentials(string)
    @user      = string.split(':').first
    @password  = string.split(':').last
  end

  # open session and block until connection is initialized
  def open_session(ssh)
    sftp = Net::SFTP::Session.new(ssh)
    sftp.loop { sftp.opening? }
    sftp
  end

  def open(uploader, *args)
    Rails.logger("Starting upload...")
  end

  def close(uploader, *args)
    Rails.logger("Upload complete")
  end

  def finish(uploader, *args)
    Rails.logger("All done")
  end

  end
end
