require "transport_gateway/engine"
require "mongoid" 
require "slim"
require "uri/aws3"

module TransportGateway
  MARKET_KINDS  = [:aca_shop, :aca_individual, :aca_congress, :any]
  SITE_KEYS     = [:dchbx, :cca]

end
