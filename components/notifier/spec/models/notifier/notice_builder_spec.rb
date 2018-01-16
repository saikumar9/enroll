require 'rails_helper'

module Notifier
  RSpec.describe NoticeBuilder, type: :model do

    describe '.construct_notice_object' do
      subject { Notifier::NoticeKind.new }
      let!(:person) { FactoryGirl.build(:person) }
      let!(:employee_role) { FactoryGirl.build(:employee_role, person: person) }
      let!(:notice_template_employee) { FactoryGirl.build(:notifier_template, data_elements: ["employee_profile.employer_name"]) }

      let!(:employer_profile) { FactoryGirl.create(:employer_with_planyear)}
      let!(:notice_template_employer) { FactoryGirl.build(:notifier_template, data_elements: ["employer_profile.plan_year.current_py_start_on.year"])}
      let!(:plan_year) { employer_profile.plan_years.first }
      let!(:pay_load) { {"event_object_kind" => "PlanYear", "event_object_id" => plan_year.id.to_s} }

      it 'should return merge model of employee_profile' do
        allow_any_instance_of(Notifier::NoticeKind).to receive(:recipient).and_return("EmployeeProfile")
        allow_any_instance_of(Notifier::NoticeKind).to receive(:resource).and_return(employee_role)
        allow_any_instance_of(Notifier::NoticeKind).to receive(:payload).and_return("rspec-enrollment-payload")
        allow_any_instance_of(Notifier::NoticeKind).to receive(:template).and_return(notice_template_employee)
        value = subject.construct_notice_object
        # once it is been constructed creates default attributes but do not assign till we pass notice_template data elements
        expect(value.employer_name).to eq employee_role.employer_profile.legal_name
        expect(value.enrollment).not_to be nil
        expect(value.enrollment.coverage_start_on).to eq nil
      end

      it 'should return merge model of employer_profile' do
        allow_any_instance_of(Notifier::NoticeKind).to receive(:recipient).and_return("EmployerProfile")
        allow_any_instance_of(Notifier::NoticeKind).to receive(:resource).and_return(employer_profile)
        allow_any_instance_of(Notifier::NoticeKind).to receive(:payload).and_return(pay_load)
        allow_any_instance_of(Notifier::NoticeKind).to receive(:template).and_return(notice_template_employer)
        value =  subject.construct_notice_object
        expect(value.plan_year.current_py_start_on).to eq employer_profile.plan_years.first.start_on
      end
    end

    describe '.create_secure_inbox_message' do
      subject { Notifier::NoticeKind.new }
      # we are using mocks since in this function we are trying to save record
      # each time we create a factory it will be saved to over come that we mock the save!
      let!(:person_messages) { double("Message", {subject: nil, body: nil, from: "rspec-mhc"} )}
      let!(:person_inbox) { double( "Inbox", messages: person_messages)}
      let!(:person) { double("Person", id: "person-id", inbox: person_inbox, save!: "rspec-save-model")}
      let!(:notice) { double("Notice", id: "rspec-id", format: "rspec-format", title: "rspec-titile")}

      it 'should save the person record upon building messages on account' do
        allow_any_instance_of(Notifier::NoticeKind).to receive(:resource).and_return(person)
        allow_any_instance_of(Notifier::NoticeKind).to receive(:subject).and_return("rspec-subject")
        allow(person_messages).to receive(:build).and_return(person)
        expect(subject.create_secure_inbox_message(notice)).to eq "rspec-save-model"
      end
    end
  end
end
