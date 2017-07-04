require 'uri'

module TransportGateway
  class Message

    attr_accessor :from, :to, :body

    def initialize(from, to, body = nil, envelope_header = {}, options = {})
      # SFTP: (File) local file path
      # String
      # Certificate File
      @from = from

      # SFTP: URI#userinfo simple credentials
      @to   = to_uri(to)
      @body = body

      # Canonical Vocabulary "EnvelopeHeaderType" attributes
      parse_envelope_header(envelope_header) unless envelope_header.empty?

      parse_options(options) unless options.empty?
    end

  private 

    def to_uri(value)
      value.is_a?(URI) ? value : URI.parse(value.to_s)
    end

    def parse_envelope_header(envelope_header)
      @hbx_id                         = envelope_header[:hbx_id] || nil
      @submitted_timestamp            = envelope_header[:submitted_timestamp] || nil
      @authorization                  = envelope_header[:authorization] || nil
      @service_status_type            = envelope_header[:service_status_type] || nil
      @message_id                     = envelope_header[:message_id] || nil
      @originating_service            = envelope_header[:originating_service] || nil
      @reply_to                       = envelope_header[:reply_to] || nil
      @fault_to                       = envelope_header[:fault_to] || nil
      @correlation_id                 = envelope_header[:correlation_id] || nil
      @application_header_properties  = envelope_header[:application_header_properties] || nil
    end

    def parse_options(options)
      options.each { |k,v| instance_variable_set("@#{k}", v) }
    end

  end
end
