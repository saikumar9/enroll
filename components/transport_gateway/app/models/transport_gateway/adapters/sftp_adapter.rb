require 'net/ssh'
require 'net/sftp'

module TransportGateway
  class Adapters::SftpAdapter

    def send_message(message)
      raise ArgumentError.new "source file not provided" unless message.from.present?
      raise ArgumentError.new "target file not provided" unless message.to.present?

      source    = message.from
      target    = message.to

      if target.userinfo.present?
        user      = target.user
        password  = target.password
      else
        raise ArgumentError.new("target server username:password not provided")
      end

      Net::SFTP.start(target.host, user, password: password) do |sftp|
        find_or_create_target_folder_for(sftp, target.path) unless sftp.directory?(File.dirname(target.path))

        sftp.upload!(source.path, target.path) do |event, uploader, *args|
          send(event, uploader, *args) if respond_to?(event, true)
        end
      end
    end

    # 
    def send_messages(messages)
      handle1 = sftp.open!("/path/to/file1")
      handle2 = sftp.open!("/path/to/file2")

      r1 = sftp.read(handle1, 0, 1024)
      r2 = sftp.read(handle2, 0, 1024)

      sftp.loop { [r1, r2].any? { |r| r.pending? } }

      puts "chunk #1: #{r1.response[:data]}"
      puts "chunk #2: #{r2.response[:data]}"
    end

 private

  def find_or_create_target_folder_for(sftp, path)
    folder = File.dirname(path)
    sftp..mkdir!(folder, :permissions => 0777)
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
