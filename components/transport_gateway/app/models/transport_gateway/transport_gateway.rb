module TransportGateway
  class TransportGateway

    CREDENTIAL_KINDS = ["basic", "key"]

    def initialize
      @adapters = []
      load_adapters
    end

    def adapters
      @adapters
    end

    def send_message(message)
      adapter = adapter_for(message)
      credential = credentials(message)
      adapter.send_message(message, credential)
    end

    def adapter_for(message)
      protocol = message.to.scheme
      klass_name = protocol.capitalize + 'Adapter'
      klass_name.constantize.new
    end

    # Use message.from to reference method in message.to.host named file
    # for credential lookup.  
    # TODO: Add an environment or setting variable to hide the credentials folder in production
    def credentials(message)
      credentialer = credentials_for(message)
      credential_method = low_case(message.from) + '_credential'

      if credentialer.respond_to?(credential_method)
        return credentialer.send(credential_method, message)
      end

      nil
    end

  private
    def credentials_for(message)
      to_host = message.to.host || 'default'
      klass_name = camel_case(to_host) + "Credential"
      klass_name.constantize.new
    end

    def load_adapters
      adapter_dir = File.dirname(__FILE__)
      pattern = File.join(adapter_dir, 'adapter', '*.rb')
      Dir.glob(pattern).each do |file|
        require file
        @adapters << file.basename.rstrip('.rb').classify.constantize
      end
    end

    def camel_case(string)
      tokens = string.split('.') 
      tokens.map! {|t| t.capitalize}
      tokens.join('Dot')
    end

    def low_case(string)
      tokens = string.split('.')
      tokens.map! {|t| t.downcase}
      tokens.join('_dot_')
    end

  end
end
