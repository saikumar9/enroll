module AcaShopMarket
  module SponsorApplications
    # Business rules for determining if sponsor application meets benefit eligibility requirements
    class ApplicationEligibleForBenefitPolicy

      def initialize(application, market_place, options = {})
        @application  = application
        @market_place = market_place 
      end

      def is_eligible?
        @scores = []
        status = @application.application_eligible_for_benefit_criteria.class.fields.keys.reject{|k| k == "_id"}.reduce(true) do |eligible, element|
          if self.public_send("is_#{element}_eligible?")
            true && eligible
          else
            @errors << ["eligibility failed on #{element}"]
            false
          end
        end

        return status, @scores
      end

      private

      def is_market_place_eligible?
        if @application.parent.class_name.to_s    == "EmployerProfile" 
        elsif @application.parent.class_name.to_s == "Hbx" 
        elsif @application.parent.class_name.to_s == "Congress" 
        else
        end
      end

    end
  end
end