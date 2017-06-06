module AcaShopMarket
  module SponsorApplications
    # Service class for terminating employer sponsored benefit
    module ApplicationTerminator

      def initialize(employer_profile, benefit_application, termination_date)
        @employer_profile     = employer_profile
        @benefit_application  = benefit_application
        @termination_date     = termination_date
      end

      def terminate
        return false unless @employer_profile && @benefit_application && @termination_date
      end

      def may_terminate?
      end

    end
  end
end