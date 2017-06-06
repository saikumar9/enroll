module AcaShopMarket
    module SponsorContributions
      module PremiumCredits
        class Base
          include Enumerable

          attr_reader :options
          
          def initialize(options={})
            @options = options || {}
          end
          

          def relationhip_categories

          end

          aca_shop_options = {  }

          aca_shop_eligibility_criteria = [
              employee: {
                primary_member_relationships:   ["self"],
                age_range:                      0..0,
                benefit_markets:                [:aca_shop],
                benefit_products:               [:health, :dental],
              }

          ]

          aca_shop_categories = 
          [
            {
              name: :employee,
              primary_member_relationships:   ["self"],
              age_range:                0..0,
              premium_percent_minimum:  50,
              premium_percent_maximum:  100,
              premium_credit_maximum:   0,
            },
            {
              name: :spouse,
              primary_member_relationships:   ["spouse"],
              age_range:                0..0,
              premium_percent_minimum:  0,
              premium_percent_maximum:  100,
              premium_credit_maximum:   0,
            },
            {
              name: :domestic_partner,
              primary_member_relationships:   ["domestic partner"],
              age_range:                0..0,
              premium_percent_minimum:  0,
              premium_percent_maximum:  100,
              premium_credit_maximum:   0,
            },
            {
              name: :child_under_26,
              primary_member_relationships:   ["child", "step-child"],
              age_range:                0..25,
              premium_percent_minimum:  0,
              premium_percent_maximum:  100,
              premium_credit_maximum:   0,
            },
          ]


          congress_2017_categories =
          [
            { 
              name: :employee_only,
              premium_percent_minimum:  75,
              premium_percent_maximum:  75,
              premium_credit_maximum:   480.29,
            },
            {
              name: :employee_plus_one,
              premium_percent_minimum:  75,
              premium_percent_maximum:  75,
              premium_credit_maximum:   1030.88,
            },
            {
              name: :employee_plus_many,
              premium_percent_minimum:  75,
              premium_percent_maximum:  75,
              premium_credit_maximum:   1094.64,
            }
          ]

          mhc_composite_categories = 
          [
            { 
              name: :employee_only,
              premium_percent_minimum:  50,
              premium_percent_maximum:  100,
              premium_credit_maximum:   0,
            },
            {
              name: :employee_and_spouse,
              premium_percent_minimum:  50,
              premium_percent_maximum:  100,
              premium_credit_maximum:   0,
            },
            {
              name: :employee_and_one_other_dependent,
              premium_percent_minimum:  50,
              premium_percent_maximum:  100,
              premium_credit_maximum:   0,
            },
            {
              name: :family,
              premium_percent_minimum:  50,
              premium_percent_maximum:  100,
              premium_credit_maximum:   0,
            }

          ]


          def self.included(base)
            base.extend ClassMethods
          end

        end

        module ClassMethods
          # Convert the name (string or symbol) to a premium credit class.
          # For example: class_for_name(:composite) returns a CompositePremiumCredit class
          def class_for_name(name)
            AcaShopMarket::SonsorContributions::PremiumCredits.const_get("#{name.to_s.camelize}PremiumCredit")
          end
        end
      end
    end
end