namespace :notice_test do
  desc "Load the carrier data"
  task :notice_rake => :environment do
    emp = FactoryGirl.create(:notices_employer_profile, :employer_with_renewing_planyear, :adds)
    org = emp.organization
    py1 = emp.plan_years.first
    py2 = emp.plan_years.last
    bg1 = emp.plan_years.first.benefit_groups.first
    bg2 = emp.plan_years.last.benefit_groups.first
    cp1 = bg1.reference_plan.carrier_profile
    cp2 = bg2.reference_plan.carrier_profile
    ce_owner = FactoryGirl.create(:census_employee, :owner, employer_profile: emp)
    ce = FactoryGirl.create(:census_employee, hired_on: TimeKeeper.date_of_record - 19.months, employer_profile: emp)
    ce1 = FactoryGirl.create(:census_employee, hired_on: TimeKeeper.date_of_record - 18.months, employer_profile: emp)
    FactoryGirl.create(:benefit_group_assignment, benefit_group: bg1, census_employee: ce)
    FactoryGirl.create(:benefit_group_assignment, benefit_group: bg2, census_employee: ce)
    FactoryGirl.create(:benefit_group_assignment, benefit_group: bg1, census_employee: ce1)
    FactoryGirl.create(:benefit_group_assignment, benefit_group: bg2, census_employee: ce1)
    p1 = Plan.find(bg1.reference_plan_id)
    rate_calc = CompositeRatingBaseRatesCalculator.new(bg1, p1)
    rate_calc.assign_final_premiums
    puts org.legal_name
    puts "Success"
    person = FactoryGirl.create(:person, ssn: ce.ssn, dob: ce.dob, gender: ce.gender, first_name: ce.first_NAME, last_name: ce.last_name)
    person1 = FactoryGirl.create(:person, ssn: ce1.ssn, dob: ce1.dob, gender: ce1.gender, first_name: ce1.first_NAME, last_name: ce1.last_name)
    emp_role = FactoryGirl.create(:employee_role, employer_profile: org.employer_profile, person: person)
    emp_role1 = FactoryGirl.create(:employee_role, employer_profile: org.employer_profile, person: person1)
    ce.update_attributes(employee_role_id: emp_role.id)
    ce1.update_attributes(employee_role_id: emp_role1.id)
    FactoryGirl.create(:qualifying_life_event_kind, market_kind: "shop")
    FactoryGirl.create(:qualifying_life_event_kind, :effective_on_event_date, market_kind: "shop")
    Caches::PlanDetails.load_record_cache!
    debugger
    emp.census_employees.non_business_owner.all.each do |ce|
      debugger
      person_record = Person.where(first_name: ce.first_name, last_name: ce.last_name, ssn: ce.ssn)
      FactoryGirl.create :family, :with_primary_family_member, person: person_record
      u = FactoryGirl.create(:user, person: person_record,
                                   email: person[:email],
                                   password: "Abcd1234!",
                                   password_confirmation: "Abcd1234!")
      puts u
      puts "superb"
    end
    sic_factors = SicCodeRatingFactorSet.new(active_year: py1.start_on.year, default_factor_value: 1.0, carrier_profile: cp1).tap do |factor_set|
      factor_set.rating_factor_entries.new(factor_key: emp.sic_code, factor_value: 1.0)
    end
    sic_factors.save!
    group_size_factors = EmployerGroupSizeRatingFactorSet.new(active_year: py1.start_on.year, default_factor_value: 1.0, max_integer_factor_key: 5, carrier_profile: cp1).tap do |factor_set|
      [0..5].each do |size|
        factor_set.rating_factor_entries.new(factor_key: size, factor_value: 1.0)
      end
    end
    group_size_factors.save!
    sic_factors = SicCodeRatingFactorSet.new(active_year: py2.start_on.year, default_factor_value: 1.0, carrier_profile: cp1).tap do |factor_set|
      factor_set.rating_factor_entries.new(factor_key: emp.sic_code, factor_value: 1.0)
    end
    sic_factors.save!
    group_size_factors = EmployerGroupSizeRatingFactorSet.new(active_year: py2.start_on.year, default_factor_value: 1.0, max_integer_factor_key: 5, carrier_profile: cp2).tap do |factor_set|
      [0..5].each do |size|
        factor_set.rating_factor_entries.new(factor_key: size, factor_value: 1.0)
      end
    end
    group_size_factors.save!
  end
end