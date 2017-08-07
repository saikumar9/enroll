module PdfTemplates
  class BrokerNotice
    include Virtus.model

    attribute :primary_identifier, String
    attribute :primary_address, PdfTemplates::NoticeAddress
    attribute :broker, PdfTemplates::Broker
    attribute :hbe, PdfTemplates::Hbe
    attribute :plan, PdfTemplates::Plan
    attribute :er_fullname, String
    attribute :er_legal_name, String

    def shop?
      return true
    end
  end
end
