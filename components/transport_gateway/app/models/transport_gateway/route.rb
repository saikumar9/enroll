# Class for configuring well-known endpoints for site
module TransportGateway
  class Route
    include Mongoid::Document

    attr_accessor :body
    attr_reader :target_uri

    field :title, type: String
    field :description, type: String
    field :target_uri, type: String

    embeds_one :credential

    def source_file(new_file)
      @source_file = File.new(new_file) unless new_file.is_a? File
    end

    def send_message
      message = Message.new(from: @source_file, to: target_uri, body: @body)
      gateway = Gateway.new()
      gateway.send_message(message)
    end

  end
end
