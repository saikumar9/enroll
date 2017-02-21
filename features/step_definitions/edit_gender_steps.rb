Given(/^I am a consumer$/) do
  @person_all = FactoryGirl.create(:person, :with_family, :with_consumer_role, :with_employee_role, :male)
  @family_all = @person_all.primary_family
  FactoryGirl.create(:hbx_profile, :no_open_enrollment_coverage_period)
  qle_all = FactoryGirl.create(:qualifying_life_event_kind, market_kind: "shop")
  FactoryGirl.create(:special_enrollment_period, family: @family_all, effective_on_kind:"date_of_event", qualifying_life_event_kind_id: qle_all.id)
  all_er_profile = FactoryGirl.create(:employer_profile)
  all_census_ee = FactoryGirl.create(:census_employee, employer_profile: all_er_profile)
  @person_all.employee_roles.first.census_employee = all_census_ee
  @person_all.employee_roles.first.save!
  @family_all = Family.find(@family_all.id)
  Caches::PlanDetails.load_record_cache!
end

Given(/^my gender is set to male$/) do
  expect(@person_all.gender).to eq "male"
end

When(/^I visit the Families Home Page$/) do
  begin
    find_button('Manage Family').visible?
  rescue Exception=>e
    binding.pry
  end
end

When(/^then I click on the Manage Family link\.$/) do
  click_link('Manage Family')
  find_link('Personal').visible?
  click_link('Personal')
end

Then(/^male should be selected$/) do
  expect(page).to have_content "person[gender]"
  expect("person[gender]").to eq "male"
end

Then(/^I click female$/) do
  choose("radio_female")
end

Then(/^I click Save$/) do
  page.find_button("Save").trigger("click")
end

Then(/^Person was successfully updated appears\.$/) do
  expect(page).to have_content "Person was successfully updated."
  expect(person_all.gender).to eq "female"
end