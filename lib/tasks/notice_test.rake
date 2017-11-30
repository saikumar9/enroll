namespace :notice_test do
  desc "Load the carrier data"
  task :notice_rake1 => :environment do
    COMPOSITE_TIER_TRANSLATIONS ||= {
      'Employee': 'employee_only',
      'Employee + Spouse': 'employee_and_spouse',
      'Employee + Dependent(s)': 'employee_and_one_or_more_dependents',
      'Family': 'family'
    }.with_indifferent_access
    Caches::PlanDetails.load_record_cache!
    cps = ENV['cp'].split(' ').uniq
    cps.each do |sp|
      emp = FactoryGirl.create(:notices_employer_profile, :employer_with_renewing_planyear, :adds, cp: sp)
      org = emp.organization
      py1 = emp.plan_years.first
      #can_renew_plan_year(emp.plan_years.first.benefit_groups.first)
      bg1 = emp.plan_years.first.benefit_groups.first
      ce_owner = FactoryGirl.create(:census_employee, :owner, employer_profile: emp)
      ce = FactoryGirl.create(:census_employee, hired_on: TimeKeeper.date_of_record - 16.months, employer_profile: emp)
      ce1 = FactoryGirl.create(:census_employee, hired_on: TimeKeeper.date_of_record - 18.months, employer_profile: emp)
      ce2 = FactoryGirl.create(:census_employee, hired_on: TimeKeeper.date_of_record - 17.months, employer_profile: emp)
      ce3 = FactoryGirl.create(:census_employee, hired_on: TimeKeeper.date_of_record - 17.months, employer_profile: emp)
      ce4 = FactoryGirl.create(:census_employee, hired_on: TimeKeeper.date_of_record - 18.months, employer_profile: emp)
      ce6 = FactoryGirl.create(:census_employee, hired_on: TimeKeeper.date_of_record - 16.months, employer_profile: emp)
      puts "Organization name is #{org.legal_name}"
      emp.census_employees.all.each do |cemp|
        person_record = FactoryGirl.create(:person, ssn: cemp.ssn, dob: cemp.dob, gender: cemp.gender, first_name: cemp.first_name, last_name: cemp.last_name)
        u = FactoryGirl.create(:user, person: person_record,
                                     email: cemp.email.address,
                                     oim_id: cemp.email.address,
                                     password: "Abcd1234!",
                                     password_confirmation: "Abcd1234!")
        puts "Census Employee id is #{u.id}"
        Factories::EnrollmentFactory.build_employee_role(person_record, person_record, emp, cemp, cemp.hired_on)
      end
      emp.employee_roles.each do |er|
        hbex = FactoryGirl.create(:hbx_enrollment, :open_enrollment, :shop, :with_enrollment_members, enrollment_members: er.families.family_members, household: er.families.households.first,
         effective_on: py1.start_on, plan_id: bg1.reference_plan_id, benefit_group_id: bg1.id,
         benefit_group_assignment_id: er.census_employee.benefit_group_assignments.where(aasm_state: "initialized").first.id)
        er.census_employee.benefit_group_assignments.where(aasm_state: "initialized").first.update_attributes!(aasm_state: "coverage_selected", hbx_enrollment_id: hbex.id)
        hbex.record_transition
      end
      today = TimeKeeper.date_of_record
      py1.advance_date! if today > py1.open_enrollment_end_on
      py1.advance_date! if today >= py1.start_on
      py1.advance_date! if today > py1.start_on
      ce2.terminate_employment!(TimeKeeper.date_of_record - 7.days)
      ce6.terminate_employment!(TimeKeeper.date_of_record + 7.days)
      ce3.terminate_employment!(TimeKeeper.date_of_record - 10.days)
      ce4.terminate_employment!(TimeKeeper.date_of_record - 5.days)
      ce4.reload
      ce3.reload
      rehire_census_employee(ce3, TimeKeeper.date_of_record - 5.days)
      cobra_census_employee(ce4, TimeKeeper.date_of_record.next_month + 5.days)
      renewal_factory = Factories::PlanYearRenewalFactory.new
      renewal_factory.employer_profile = emp
      renewal_factory.is_congress = false
      renewal_factory.renew
    end
  end

  private
  def rehire_census_employee(ce, rehired_date)
    new_ce = ce.replicate_for_rehire
    new_ce.hired_on = rehired_date
    if new_ce.valid? && ce.valid?
       ce.save!
       new_ce.save!
       new_ce.build_address if new_ce.address.blank?
       new_ce.add_default_benefit_group_assignment
       new_ce.construct_employee_role_for_match_person
    end
  end

  def cobra_census_employee(ce, cobra_date)
    ce.update_for_cobra(cobra_date, nil)  if ce.can_elect_cobra?
  end
end
