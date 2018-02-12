require 'securerandom'

module TransportProfiles
  class EndpointNotFoundError < StandardError; end
  class AmbiguousEndpointError < StandardError; end

  class Steps::RouteTo < Steps::Step

    # Create an instance of the step.
    # @param endpoint_key [Symbol] a key representing the name of the endpoint to which the resources will be sent
    # @param file_name [URI, Symbol] represents the path of the resource being transported.
    #   If a URI, is the URI of the source resource.
    #   If a Symbol, represents a URI or collection of URIs stored in the process context.
    # @param gateway [TransportGateway::Gateway] the transport gateway instance to use for moving of resoruces
    # @param destination_file_name [String] Optional. Specifies a file name for the resource to be stored, if it must be exact.  Not used when the source resource is a list of URIs obtained from the process context.
    # @param source_credentials [Symbol, TransportProfiles::Credential] Optional.  Specifies the credentials for the source resources when needed.  This is usually used when your source is a collection of multiple resources.
    #   If a symbol, is the key of an endpoint, which is then used to resolve the credentials.
    #   If an instance of {TransportProfiles::Credential}, is used directly.
    def initialize(endpoint_key, file_name, gateway, destination_file_name: nil, source_credentials: nil)
      super("Route: ##{file_name} to #{endpoint_key}", gateway)
      @endpoint_key = endpoint_key
      @file_name = file_name
      @target_file_name = destination_file_name
      @source_credentials = source_credentials
    end

    def execute
      endpoints = ::TransportProfiles::WellKnownEndpoint.find_by_endpoint_key(@endpoint_key)
      raise ::TransportProfiles::EndpointKeyNotFoundError unless endpoints.size > 0
      raise ::TransportProfiles::AmbiguousEndpointError, "More than one matching endpoint found" if endpoints.size > 1
      file_uri = @file_name.respond_to?(:scheme) ? @file_name : URI.parse(@file_name)

      endpoint = endpoints.first
      uri = complete_uri_for(endpoint, file_uri)

      message = ::TransportGateway::Message.new(from: file_uri, to: uri, destination_credentials: endpoint, source_credentials: @source_credentials)

      @gateway.send_message(message)
    end

    # @!visibility private
    def complete_uri_for(endpoint, file_uri)
      base_name = @target_file_name.blank? ? File.basename(file_uri.path) : @target_file_name
      endpoint_uri = URI.parse(endpoint.uri)
      case endpoint_uri.scheme
      when 's3'
        # The frequently changing bits of the UUID are at the end,
        # so flip it to make aws shard-happy
        random_portion = SecureRandom.uuid.gsub("-", "").reverse
        URI.join(endpoint.uri, random_portion + "_" + base_name)
      when 'sftp'
        URI.join(endpoint.uri, base_name)
      end
    end
  end


end
