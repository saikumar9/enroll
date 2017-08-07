module TransportGateway
  class WellKnownEndpoint
    include Mongoid::Document

    field :title, type: String
    field :site_key, type: Symbol
    field :key, type: Symbol
    field :market_kind, type: Symbol
    field :uri, type: String

    embeds_many :credentials, class_name: "TransportGateway::Credential"

    validates_presence_of :title, :site_key, :key, :market_kind, :uri

    validates :site_key,
      inclusion: {in: SITE_KEYS, message: "%{value} is not a valid site key" }
    validates :market_kind,
      inclusion: {in: MARKET_KINDS, message: "%{value} is not a valid market kind" }

    index({key: 1})
    index({site_key: 1, key: 1, market_kind: 1})

    scope :find_by_endpoint_key,  ->(endpoint_key) { where(key: endpoint_key.to_s ) }

    # after_validation :convert_attribute_symbols_to_strings

    def active_credential
      credentials.first
    end

  end
end
