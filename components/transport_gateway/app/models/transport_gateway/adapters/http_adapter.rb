require 'net/http'
require 'uri'

module TransportGateway
  class Adapters::HttpAdapter

    def initialize(message = nil)
      send_message(message) unless message.blank?
    end

    def send_message(message)
      end_point = message.to.scheme + message.to.host + message.to.path

      # request = Net::HTTP::Put.new(message.body)
      request = Net::HTTP::Put.new(end_point)

      # request = Net::HTTP::GenricRequest.new
      # request.body_stream = message.body

      # if message.body.is_a?(String)
      # elsif message.body.is_a?(Hash)
      #   request.body = multipart_data
      #   request.content_type = 'multipart/form-data'
      # else
      #   request.body = multipart_data
      #   request.content_type = 'multipart/form-data'
      # end

      # request.set_form_data('from' => '2005-01-01', 'to' => '2005-03-31')
      # upload file
      response = Net::HTTP.start(message.to.host) do |http|
        http.request(request)
      end

      response
    end
  end
end
