namespace :notice_18945_test do
  desc "Load the carrier data"
  task :notice_rake => :environment do
    emp = FactoryGirl.create(:notices_employer_profile, :employer_with_planyear, :add)
    org = emp.organization
    bg1 = emp.plan_years.first.benefit_groups.first
    py1 = emp.plan_years.first
    cp1 = bg1.reference_plan.carrier_profile
    #bg2 = emp.plan_years.last.benefit_groups.first
    ce_owner = FactoryGirl.create(:census_employee, :owner, employer_profile: emp)
    ce = FactoryGirl.create(:census_employee, hired_on: TimeKeeper.date_of_record - 19.months, employer_profile: emp)
    ce1 = FactoryGirl.create(:census_employee, hired_on: TimeKeeper.date_of_record - 18.months, employer_profile: emp)
    FactoryGirl.create(:benefit_group_assignment, benefit_group: bg1, census_employee: ce)
    #FactoryGirl.create(:benefit_group_assignment, benefit_group: bg2, census_employee: ce)
    FactoryGirl.create(:benefit_group_assignment, benefit_group: bg1, census_employee: ce1)
    #FactoryGirl.create(:benefit_group_assignment, benefit_group: bg2, census_employee: ce1)
    p1 = Plan.find(bg1.reference_plan_id)
    rate_calc = CompositeRatingBaseRatesCalculator.new(bg1, p1)
    rate_calc.assign_final_premiums
    puts org.legal_name
    puts "Success"
    FactoryGirl.create(:qualifying_life_event_kind, market_kind: "shop")
    FactoryGirl.create(:qualifying_life_event_kind, :effective_on_event_date, market_kind: "shop")
    Caches::PlanDetails.load_record_cache!
    emp.census_employees.all.each do |cemp|
      person_record = FactoryGirl.create(:person, ssn: cemp.ssn, dob: cemp.dob, gender: cemp.gender, first_name: cemp.first_name, last_name: cemp.last_name)
      FactoryGirl.create :family, :with_primary_family_member, person: person_record
      u = FactoryGirl.create(:user, person: person_record,
                                   email: cemp.email.address,
                                   oim_id: cemp.email.address,
                                   password: "Abcd1234!",
                                   password_confirmation: "Abcd1234!")
      puts u.id
      puts "superb"
      emp_role = FactoryGirl.create(:employee_role, employer_profile: emp, person: person_record, census_employee_id: cemp.id)
      cemp.update_attributes!(employee_role_id: emp_role.id)
    end

    emp.employee_roles.each do |er|
      hbex = FactoryGirl.create(:hbx_enrollment, :open_enrollment, :shop, :with_enrollment_members, enrollment_members: er.families.family_members, household: er.families.households.first,
       effective_on: py1.start_on, plan_id: bg1.reference_plan_id, benefit_group_id: bg1.id,
       benefit_group_assignment_id: er.census_employee.benefit_group_assignments.where(aasm_state: "initialized").first.id)

      er.census_employee.benefit_group_assignments.where(aasm_state: "initialized").first.update_attributes!(aasm_state: "coverage_selected", hbx_enrollment_id: hbex.id)
      hbex.record_transition
    end 
  end
end