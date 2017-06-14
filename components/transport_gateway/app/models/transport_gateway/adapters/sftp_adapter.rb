require 'net/sftp'
module TransportGateway
  class Adapters::SftpAdapter

    SftpServerHost = 'localhost'

    def send_message(message)
      to_path = message.to.path
      to_path.slice!(0)

      Net::SFTP.start(SftpServerHost, 'username', password: 'password') do |sftp|
        sftp.file.open(to_path, "w") do |f|
          f.puts message.body
        end
      end
    end

  end
end
