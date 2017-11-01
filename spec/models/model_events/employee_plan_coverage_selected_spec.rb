require 'rails_helper'

describe 'ModelEvents::EmployeePlanCoverageSelected' do

  let(:model_event)  { "application_coverage_selected" }
  let(:notice_event) { "application_coverage_selected" }
  let!(:employer) { FactoryGirl.create(:employer_profile)}
  let!(:plan_year) { FactoryGirl.create(:custom_plan_year, employer_profile: employer, aasm_state: "enrolling")}
  let!(:census_employee){  FactoryGirl.create(:census_employee, employer_profile: employer) }
  let!(:person) { FactoryGirl.create(:person, :with_family) }
  let!(:role) {  FactoryGirl.create(:employee_role, person: person, census_employee: census_employee, employer_profile: employer) }
  let!(:model_instance)   { FactoryGirl.create(:hbx_enrollment,
                                           household: person.primary_family.active_household,
                                          coverage_kind: "health",
                                          kind: "employer_sponsored",
                                          benefit_group_id: census_employee.employer_profile.plan_years.first.benefit_groups.first.id,
                                          employee_role_id: role.id,
                                          benefit_group_assignment_id: census_employee.active_benefit_group_assignment.id,
                                          aasm_state: "shopping"
  ) }


  describe "ModelEvent" do
    context "when renewal application created" do
      it "should trigger model event" do
        model_instance.observer_peers.keys.each do |observer|
          expect(observer).to receive(:hbx_enrollment_update) do |model_event|
            expect(model_event).to be_an_instance_of(ModelEvents::ModelEvent)
            expect(model_event).to have_attributes(:event_key => :application_coverage_selected, :klass_instance => model_instance, :options => {})
          end
        end
        model_instance.select_coverage!
      end
    end
  end
end
