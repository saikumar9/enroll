module TransportGateway
  class Steps::RouteTo < Step

    def initialize(endpoint_key, file_name)
      super("Route: ##{file} to #{endpoint_key}")
      @endpoint_key = endpoint_key
      @file_name = file_name
    end

    def execute
      source_file = File.new(@file_name) unless new_file.is_a?(File)
      endpoints = TransportGateway::WellKnownEndPoint.find_by_endpoint_key(:endpoint_key)
      raise TransportGateway::EndpointKeyNotFoundError unless endpoints.size > 0
      raise TransportGateway::AmbiguousEndpointError, "More than one matching endpoint found" if endpoint.size > 1

      endpoint = endpoint.first
      uri = endpoint.uri
      credential = endpoint.active_credential

      message = Message.new(from: source_file, to: uri, credential: credential)

      gateway = Gateway.new
      gateway.send_message(message)
    end

  end

  class EndpointNotFoundError < StandardError; end
  class AmbiguousEndpointError < StandardError; end

end
