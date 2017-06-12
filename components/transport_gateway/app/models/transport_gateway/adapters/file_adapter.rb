module TransportGateway
  class Adapters::FileAdapter

    def send_message(message)
      to_path = message.to.path
      to_path.slice!(0)

      File.open(to_path, 'w') do |f|
        f.write(message.body)
      end
    end

  end
end
