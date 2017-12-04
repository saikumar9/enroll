# A time period during which Organizations, including {HbxProfile}, who are eligible for a {BenefitSponsorship}, may offer
# {BenefitPackage}(s) to participants within a market place. Each {BenefitCoveragePeriod} includes an open enrollment
# period, during which eligible partipants may enroll.

class BenefitCoveragePeriod
  include CoreModelConcerns::BenefitCoveragePeriodConcern

  # Sets the ACA Second Lowest Cost Silver Plan (SLCSP) reference plan
  #
  # @raise [ArgumentError] if the referenced plan is not silver metal level
  #
  # @param new_plan [ Plan ] The reference plan.
  def second_lowest_cost_silver_plan=(new_plan)
    raise ArgumentError.new("expected Plan") unless new_plan.is_a?(Plan)
    raise ArgumentError.new("slcsp metal level must be silver") unless new_plan.metal_level == "silver"
    self.slcsp_id = new_plan._id
    self.slcsp = new_plan._id
    @second_lowest_cost_silver_plan = new_plan
  end

  # Gets the ACA Second Lowest Cost Silver Plan (SLCSP) reference plan
  #
  # @return [ Plan ] reference plan
  def second_lowest_cost_silver_plan
    return @second_lowest_cost_silver_plan if defined? @second_lowest_cost_silver_plan
    @second_lowest_cost_silver_plan = Plan.find(slcsp_id) unless slcsp_id.blank?
  end

  # @todo Available products from which this sponsor may offer benefits during this benefit coverage period
  def benefit_products
  end

  # Determine list of available products (plans), based on member enrollment eligibility for each {BenefitPackage} under this
  # {BenefitCoveragePeriod}. In the Individual market, BenefitPackage types may include Catastrophic, Cost Sharing
  # Reduction (CSR), etc., and eligibility criteria such as member age, ethnicity, residency and lawful presence.
  #
  # @param hbx_enrollment_members [ Array ] the list of enrolling members
  # @param coverage_kind [ String ] the benefit type.  Only 'health' is currently supported
  # @param tax_household [ TaxHousehold ] the tax household members belong to if eligible for financial assistance
  #
  # @return [ Array<Plan> ] the list of eligible products
  def elected_plans_by_enrollment_members(hbx_enrollment_members, coverage_kind, tax_household=nil)
    ivl_bgs = []
    benefit_packages.each do |bg|
      satisfied = true
      family = hbx_enrollment_members.first.hbx_enrollment.family
      hbx_enrollment_members.map(&:family_member).each do |family_member|
        consumer_role = family_member.person.consumer_role
        resident_role = family_member.person.resident_role
        unless resident_role.nil?
          rule = InsuredEligibleForBenefitRule.new(resident_role, bg, coverage_kind: coverage_kind, family: family)
        else
          rule = InsuredEligibleForBenefitRule.new(consumer_role, bg, { coverage_kind: coverage_kind, family: family, new_effective_on: hbx_enrollment_members.first.hbx_enrollment.effective_on })
        end
        satisfied = false and break unless rule.satisfied?[0]
      end
      ivl_bgs << bg if satisfied
    end

    ivl_bgs = ivl_bgs.uniq
    elected_plan_ids = ivl_bgs.map(&:benefit_ids).flatten.uniq
    Plan.individual_plans(coverage_kind: coverage_kind, active_year: start_on.year, tax_household: tax_household).by_plan_ids(elected_plan_ids).entries
  end
end
