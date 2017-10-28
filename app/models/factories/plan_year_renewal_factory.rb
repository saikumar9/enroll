module Factories
  class PlanYearRenewalFactory
    include Mongoid::Document

    EARLIEST_RENEWAL_START_ON = Settings.aca.shop_market.renewal_application.earliest_start_prior_to_effective_on.months

    attr_accessor :employer_profile, :is_congress


    def initialize
      @logger = Logger.new("#{Rails.root}/log/plan_year_renewal_factory_logfile.log")
    end

    def renew
      @employer_profile = employer_profile
      @logger.debug "processing #{employer_profile.legal_name}"

      begin

        if @employer_profile.may_enroll_employer?
          @employer_profile.enroll_employer!
        elsif @employer_profile.may_force_enroll?
          @employer_profile.force_enroll!
        end

        validate_employer_profile

        @active_plan_year = @employer_profile.active_plan_year

        @plan_year_start_on = @active_plan_year.end_on + 1.day
        @plan_year_end_on   = @active_plan_year.end_on + 1.year

        open_enrollment_start_on = @plan_year_start_on - 2.months
        open_enrollment_end_on = Date.new((@plan_year_start_on - 1.month).year, (@plan_year_start_on - 1.month).month, Settings.aca.shop_market.renewal_application.monthly_open_enrollment_end_on)

        @renewal_plan_year = @employer_profile.plan_years.build({
          start_on: @plan_year_start_on,
          end_on: @plan_year_end_on,
          open_enrollment_start_on: open_enrollment_start_on,
          open_enrollment_end_on: open_enrollment_end_on,
          fte_count: @active_plan_year.fte_count,
          pte_count: @active_plan_year.pte_count,
          msp_count: @active_plan_year.msp_count
        })

        if @renewal_plan_year.may_renew_plan_year?
          @renewal_plan_year.renew_plan_year
        else
          raise PlanYearRenewalFactoryError,
          "For employer: #{@employer_profile.inspect}, \n" \
          "PlanYear state: #{@renewal_plan_year.aasm_state} cannot transition to renewing_draft"
        end

        @renewal_plan_year.benefit_groups = @active_plan_year.benefit_groups.collect{|active_group| clone_benefit_group(active_group) }

        if @renewal_plan_year.save
          populate_census_employee_benefit_packages
          @renewal_plan_year
        else
          raise PlanYearRenewalFactoryError,
          "For employer: #{@employer_profile.inspect}, \n" \
          "Error(s): \n #{@renewal_plan_year.errors.map{|k,v| "#{k} = #{v}"}.join(" & \n")} \n" \
          "Unable to save renewal plan year: #{@renewal_plan_year.inspect}"
        end
      rescue Exception => e
        @logger.debug e.inspect
      end
    end

    private

    def populate_census_employee_benefit_packages
      @active_plan_year.benefit_groups.each do |active_group|
        renewal_group = @renewal_plan_year.benefit_groups.detect{|r_group| r_group.title.scan(/#{active_group.title.strip}/i).present? }
        renew_census_employees(active_group, renewal_group)
      end
    end

    def validate_employer_profile
      if @employer_profile.plan_years.renewing.any?
        raise PlanYearRenewalFactoryError, "Employer #{@employer_profile.legal_name} already renewed"
      end

      unless PlanYear::PUBLISHED.include? @employer_profile.active_plan_year.aasm_state
        raise PlanYearRenewalFactoryError, "Renewals require an existing, published Plan Year"
      end

      unless TimeKeeper.date_of_record <= @employer_profile.active_plan_year.end_on
        raise PlanYearRenewalFactoryError, "Renewal time period has expired.  You must submit a new application"
      end
    end

    def renewal_elected_plan_ids(active_group)
      start_on_year = (active_group.start_on + 1.year).year
      if active_group.plan_option_kind == "single_carrier"
        Plan.by_active_year(start_on_year).shop_market.health_coverage.by_carrier_profile(active_group.reference_plan.carrier_profile).and(hios_id: /-01/).map(&:id)
      elsif active_group.plan_option_kind == "metal_level"
        Plan.by_active_year(start_on_year).shop_market.health_coverage.by_metal_level(active_group.reference_plan.metal_level).and(hios_id: /-01/).map(&:id)
      elsif active_group.plan_option_kind == "sole_source"        
        reference_plan_id = Plan.find(active_group.reference_plan_id).renewal_plan_id
        plans = [reference_plan_id]
      else
        Plan.where(:id.in => active_group.elected_plan_ids).map(&:renewal_plan_id)
      end
    end

    def service_area_plan_hios_ids(carrier_id)
      profile_and_service_area_pairs = CarrierProfile.carrier_profile_service_area_pairs_for(@employer_profile, @renewal_plan_year.start_on.year)
      Plan.valid_shop_health_plans_for_service_area("carrier", carrier_id, @renewal_plan_year.start_on.year, profile_and_service_area_pairs.select { |pair| pair.first == carrier_id }).pluck(:hios_id)
    end

    def clone_benefit_group(active_group)
      index = @active_plan_year.benefit_groups.index(active_group) + 1
      new_year = @active_plan_year.start_on.year + 1
      renewal_plan = Plan.find(active_group.reference_plan_id).renewal_plan

      if renewal_plan.blank?
        raise PlanYearRenewalFactoryError, "Unable to find renewal for referenence plan: Id #{active_group.reference_plan.id} Year #{active_group.reference_plan.active_year} Hios #{active_group.reference_plan.hios_id}"
      end

      reference_plan_id = renewal_plan.id
 
      if active_group.sole_source?
        service_area_hios = service_area_plan_hios_ids(active_group.reference_plan.carrier_profile_id)

        if !service_area_hios.include?(renewal_plan.hios_id)
          raise PlanYearRenewalFactoryError, "Unable to renew. renewal plan for referenence plan: #{active_group.reference_plan.id} not offered in employer service areas"
        end
      end

      elected_plan_ids = renewal_elected_plan_ids(active_group)
      if elected_plan_ids.blank?
        raise PlanYearRenewalFactoryError, "Unable to find renewal for elected plans: #{active_group.elected_plan_ids}"
      end

      benefit_group_attrs = {
        title: "#{active_group.title} (#{new_year})",
        effective_on_kind: "first_of_month",
        terminate_on_kind: active_group.terminate_on_kind,
        plan_option_kind: active_group.plan_option_kind,
        default: active_group.default,
        effective_on_offset: active_group.effective_on_offset,
        employer_max_amt_in_cents: active_group.employer_max_amt_in_cents,
        relationship_benefits: active_group.relationship_benefits,
        reference_plan_id: reference_plan_id,
        elected_plan_ids: elected_plan_ids,
        is_congress: active_group.is_congress
      }

      benefit_group_attrs.merge!({composite_tier_contributions: active_group.composite_tier_contributions}) if active_group.sole_source?
      @renewal_plan_year.benefit_groups.build(benefit_group_attrs)
    end

    def renew_census_employees(active_group, new_group)
      eligible_employees(active_group).each do |census_employee|
        if census_employee.active_benefit_group_assignment #&& census_employee.active_benefit_group_assignment.benefit_group_id == active_group.id
          census_employee.add_renew_benefit_group_assignment(new_group)

          unless census_employee.renewal_benefit_group_assignment.save
            raise PlanYearRenewalFactoryError, "For employer: #{@employer_profile.inspect}, unable to save census_employee: #{census_employee.inspect}"
          end
        end
      end
      true
    end

    def eligible_employees(active_group)
      CensusEmployee.by_benefit_group_ids([BSON::ObjectId.from_string(active_group.id.to_s)]).active
    end

    def generate_employee_role_notices
    end

    def generate_employer_profile_notices
    end
  end

  class PlanYearRenewalFactoryError < StandardError; end
end
