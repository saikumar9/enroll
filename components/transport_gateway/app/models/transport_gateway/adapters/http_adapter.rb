require 'openssl'
require 'net/http'

module TransportGateway
  class Adapters::HttpAdapter

    def send_message(message)
      resource    = message.to
      body        = message.body
      put_request = request_for(resource, body)

      http_site(resource) do |http, uri|
        http.request(put_request)
      end
    end

  private

    def request_for(uri, body)
      request = Net::HTTP::Put.new(uri.path)
      request.basic_auth(uri.user, uri.password) unless uri.userinfo.blank?

      request_body_for(request, body)
    end

    def request_body_for(request, content)

      case content
      when String
        request.set_content_type('text/plain')
        request.body = content
      when File
        request.set_content_type('text/plain')
        request.body_stream = content
      # when content == IoStream
      #   request.set_content_type('text/plain')
      #   request.body_stream = content
      when nil
        request.body = nil
      else
        request.body = content
      end
      request
    end

    def http_site(uri)
      Net::HTTP.start(uri.host, uri.port) do |http|
        yield(http, uri)
      end
    end

  end
end