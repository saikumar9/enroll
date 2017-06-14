module TransportGateway
  class TransportGateway
    include Mongoid::Document

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

  private
    def load_adapters
      adapter_dir = File.dirname(__FILE__)
      pattern = File.join(adapter_dir, 'adapter', '*.rb')
      Dir.glob(pattern).each {|file| require file }
    end

  end
end
