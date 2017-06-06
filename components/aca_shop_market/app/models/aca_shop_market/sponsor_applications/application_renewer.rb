module AcaShopMarket
  module SponsorApplications
    # Service class for renewing employer sponsored benefit
    module ApplicationRenewer

      def initialize(employer_profile, benefit_application, renewal_date)
        @employer_profile     = employer_profile
        @benefit_application  = benefit_application
        @renewal_date         = renewal_date
      end

      # Return new instance of application in renewing state
      def renew
        @renewing_benefit_application
      end

      def may_renew?
      end

    end
  end
end