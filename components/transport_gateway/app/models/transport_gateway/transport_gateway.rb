module TransportGateway
  class TransportGateway

    def initialize
      load_adapters
    end

    def send_message(message)
      adapter = adapter_for(message)
      adapter.send_message
    end

    def adapter_for(message)
      protocol = message.to.scheme
      klass_name = protocol.capitalize + 'Adapter'
      klass_name.constantize.new
    end

    def adapters
      @adapters
    end

  private
    def load_adapters
      adapter_dir = File.dirname(__FILE__)
      pattern = File.join(adapter_dir, 'adapter', '*.rb')
      Dir.glob(pattern).each do |file|
        require file 
        # @adapters << 
      end
    end

  end
end
