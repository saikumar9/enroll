namespace :notice_18945_test do
  desc "Load the carrier data"
  task :notice_rake => :environment do
    emp = FactoryGirl.create(:notices_employer_profile, :employer_with_renewing_planyear, :add)
    org = emp.organization
    bg1 = emp.plan_years.first.benefit_groups.first
    bg2 = emp.plan_years.last.benefit_groups.first
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
    emp_role = FactoryGirl.create(:employee_role, employer_profile: organization.employer_profile)
    emp_role1 = FactoryGirl.create(:employee_role, employer_profile: organization.employer_profile)
    ce.update_attributes(employee_role_id: emp_role.id)
    ce1.update_attributes(employee_role_id: emp_role1.id)
    FactoryGirl.create(:qualifying_life_event_kind, market_kind: "shop")
    FactoryGirl.create(:qualifying_life_event_kind, :effective_on_event_date, market_kind: "shop")
    Caches::PlanDetails.load_record_cache!
  end
end