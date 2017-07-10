module TransportGateway
  # Shared resources and methods
  ADAPTER_FOLDER    = "adapters"
  CREDENTIAL_FOLDER = "credentials"
  CREDENTIAL_KINDS  = ["basic", "key"]

  class Gateway

    def initialize
      @adapters = []
      load_adapters
    end

    def adapters
      @adapters
    end

    def send_message(message)
      adapter = adapter_for(message)
      # credential = credentials_for(message)
      adapter.send_message(message)
    end

  private

    def adapter_folder
      "adapters"
    end

    def adapter_for(message)
      message.to.scheme == "ftp" ? protocol = "sftp" : protocol = message.to.scheme

      adapter_klass = klass_for(TransportGateway::ADAPTER_FOLDER, protocol)
      adapter_klass.new
    end

    def klass_for(component_folder, component_name)
      namespace_path = self.class.name.deconstantize.underscore + "/" + component_folder
      klass_name = namespace_path + '/' + component_name + '_' + component_folder.singularize
      klass_name.camelize.safe_constantize
    end

    def load_adapters
      adapter_dir = File.dirname(__FILE__)
      pattern = File.join(adapter_dir, TransportGateway::ADAPTER_FOLDER, '*.rb')

      Dir.glob(pattern).each do |file|
        require file
        @adapters << File.basename(file, '.rb').to_sym
      end
    end

    def credentials_for(message)
      credentialer = credentials_token(message)
      credential_method = low_case(message.from) + '_credential'

      if credentialer.respond_to?(credential_method)
        return credentialer.send(credential_method, message)
      end

      nil
    end

    def credentials_token(message)
      to_host = message.to.host || 'default'
      klass_name = camel_case(to_host) + "Credential"
      klass_name.constantize.new
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
