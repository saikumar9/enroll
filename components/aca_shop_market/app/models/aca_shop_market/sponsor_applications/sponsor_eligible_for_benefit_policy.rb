module AcaShopMarket
  module SponsorApplications
    # Busines rules for determining if sponsor organization may offer sponsored benefit
    class SponsorEligibleForBenefitPolicy

      def initialize(sponsor, market, options = {})
        @sponsor = sponsor
        @market  = market 
      end

      def is_eligible?
        @scores = []
        status = @sponsor.sponsor_eligible_for_benefit_criteria.class.fields.keys.reject{|k| k == "_id"}.reduce(true) do |eligible, element|
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

      def is_market_eligible?
        if @sponsor.parent.class_name.to_s    == "EmployerProfile" 
        elsif @sponsor.parent.class_name.to_s == "Hbx" 
        elsif @sponsor.parent.class_name.to_s == "Congress" 
        else
        end
      end

    end
  end
end