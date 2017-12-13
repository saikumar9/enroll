module AcaShopMarket
  class BenefitRates::BenefitRate
    include Mongoid::Document

      def initialize(selected_plan, sponsor, benefit_group, reference_plan, max_cont_cache = {})
        super(selected_plan)

        @sponsor = sponsor
        @benefit_group = benefit_group
        @reference_plan = reference_plan
        @selected_plan = selected_plan
        @max_contribution_cache = max_cont_cache

        load_rate_models
      end

      def plan_year_start_on
        if @benefit_group.present?
          benefit_group.plan_year.start_on
        else
          TimeKeeper.date_of_record.beginning_of_year
        end
      end

      def total_employee_cost
      end

      def total_sponsor_contribution
      end

      def benefit_rate_for(member)
      end

      def employee_cost_for(member)
      end

      def sponsor_cost_for(member)
      end

      def calculate_total(rate)
        model = model_for(rate)
        model.calculate_rate(rate)
      end

      def max_sponsor_contribution(member)
      end

      def sponsor_contribution_percent(member)
      end

      def reference_plan_cost_for(member)
      end


    private
      def load_rate_models
        dir = File.dirname(__FILE__)
        search_pattern = File.join(dir, 'rate_models', '*.rb')
        Dir.glob(search_pattern).each { |file| require file }
      end

      def model_for(rate)
        rate_class_name = rate.capitalize + 'Rate'
        rate_klass = rate_class_name.const_get(rate_class_name)
        rate_klass.new
      end

      def child_index(member)
        @children = members.select(){|member| age_of(member) < 21} unless defined?(@children)
        @children.index(member)
      end


      [:enrolling, :waived_valid, :waived_invalid]


      def benefit_products
        [:aca_shop_health, :aca_shop_dental]
        [:single_plan, :single_carrier, :metal_level]
      end

      def rating_factors
        {
          geographic_rating_area:   "A1",
          group_enrolled_count:     1,        # participation_rate
          group_enrolled_factor: 1.022,
          participation_rate_factor: 0.998,
          sic_code: 1234,
          sic_factor: 1.032,
        }
      end

      def is_sponsor_eligible?
        {
          is_sponsor_in_good_standing: true,
          is_sponsor_eligible_to_offer_benefit_product: true,
          is_sponsor_hq_in_benefit_service_area: "A1",
          is_sponsor_member_count_range_met: 1..50,
        }

      def is_application_eligible?
        {
          is_reference_plan_designated: true,
          are_all_members_assigned_to_benefit_group: true,
          is_open_enrollment_period_valid: true,
        }
      end

      def is_enrollment_eligible?
        {
          is_participation_rate_percent_minimum_met: 75,
          is_non_owner_enrollment_participation_minimum_met: 1,
        }
      end

      def is_initial_application?
      end


      def rate_groups
        [ 
          { 
              name: :employee, 
              title: "Employee", 
              member_count: 1..1,
              employee_relationships: ["self"],
              age_range: 0..0,
              is_offered: true,
              benefit_products: [:aca_shop_health, :aca_shop_dental],

              sponsor_contribution_percent_minimum:   50,
              sponsor_contribution_currency_maximum:  0.0,
            }, 
          {
              name: :employee_and_spouse,
              title: "Employee and Spouse",
              member_count: 2..2,
              employee_relationships: ["self", "spouse", "ex-spouse", "life_partner", "domestic_partner"],
              age_range: 0..0,
            }, 
          {
              name: :employee_and_one_other_dependent,
              title: "Employee and Spouse", 
              member_count: 2..2,
              employee_relationships: ["self", "child", "adopted_child", "foster_child", "step_child", "ward", "trustee", "sponsored_dependent", "collateral_dependent" ],
              age_range: 0..0,
            }, 
          {
              name: :family, 
              title: "Family",
              member_count: 3..20,
              employee_relationships: ["self", "spouse", "ex-spouse", "life_partner", "domestic_partner", "child", "adopted_child", "foster_child", "step_child", "ward", "trustee", "sponsored_dependent", "collateral_dependent"],
              age_range: 0..0,
            }, 
        ]
      end

      def child
      end


      def self.benefit_relationship(person_relationship)
        {
          "head of household" => nil,
          "spouse" => "spouse",
          "ex-spouse" => "spouse",
          "cousin" => nil,
          "ward" => "child_under_26",
          "trustee" => "child_under_26",
          "annuitant" => nil,
          "other relationship" => nil,
          "other relative" => nil,
          "self" => "employee",
          "parent" => nil,
          "grandparent" => nil,
          "aunt_or_uncle" => nil,
          "nephew_or_niece" => nil,
          "father_or_mother_in_law" => nil,
          "daughter_or_son_in_law" => nil,
          "brother_or_sister_in_law" => nil,
          "adopted_child" => "child_under_26",
          "stepparent" => nil,
          "foster_child" => "child_under_26",
          "sibling" => nil,
          "stepchild" => "child_under_26",
          "sponsored_dependent" => "child_under_26",
          "dependent_of_a_minor_dependent" => nil,
          "guardian" => nil,
          "court_appointed_guardian" => nil,
          "collateral_dependent" => "child_under_26",
          "life_partner" => "domestic_partner",
          "child" => "child_under_26",
          "grandchild" => nil,
          "unrelated" => nil,
          "great_grandparent" => nil,
          "great_grandchild" => nil,
        }[person_relationship]
      end
  end
end
