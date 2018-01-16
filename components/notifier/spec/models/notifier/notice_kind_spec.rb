require 'rails_helper'

module Notifier
  RSpec.describe NoticeKind, type: :model do

    describe 'validators for model' do
      it { is_expected.to be_mongoid_document }
      it { is_expected.to have_fields(:title, :notice_number, :description, :identifier) }
      it { is_expected.to have_field(:recipient).of_type(String).with_default_value_of('Notifier::MergeDataModels::EmployerProfile') }
      it { is_expected.to have_field(:aasm_state).of_type(String).with_default_value_of(:draft) }
      it { is_expected.to have_field(:event_name).of_type(String).with_default_value_of(nil) }
      it { is_expected.to embed_one :cover_page }
      it { is_expected.to embed_one :template }
      it { is_expected.to embed_many(:workflow_state_transitions) }
      it { is_expected.to validate_presence_of(:title) }
      it { is_expected.to validate_presence_of(:notice_number) }
      it { is_expected.to validate_presence_of(:recipient) }
      it { is_expected.to validate_uniqueness_of(:notice_number) }
      it { is_expected.to validate_uniqueness_of(:event_name) }
      it { expect(Notifier::NoticeKind::RECIPIENTS).to have_key("Employer") }
    end

    describe 'validates keys for constant' do
      let(:params) {
        {
            "Employer" => "Notifier::MergeDataModels::EmployerProfile",
            "Employee" => "Notifier::MergeDataModels::EmployeeProfile",
            "Broker" => "Notifier::MergeDataModels::BrokerProfile"
        }
      }
      subject { Notifier::NoticeKind::RECIPIENTS }
      it { should include("Employer", "Employee", "Broker") }
      it { should_not include("GeneralAgency") }
      it { should include (params) }
    end


    describe '.set_data_elements' do
      #we can move this to fixtures we are keeping this since regex should be abale to parse
      let!(:data) { {"raw_body"=> "<p>&nbsp;</p>\r\n\r\n<p>​\#{employee_profile.notice_date}</p>\r\n\r\n<h2><strong>Enroll Now: Your Health Plan Open Enrollment Period Has Begun</strong></h2>\r\n\r\n<p>Dear ​\#{employee_profile.first_name} ​\#{employee_profile.last_name},</p>\r\n\r\n<p>Good News! \#{employee_profile.employer_name} has chosen to renew the offer of health insurance coverage to its employees through the Health Connector and will contribute to your monthly premium to make the cost of coverage more affordable. Your open enrollment period begins on \#{employee_profile.plan_year.renewal_py_oe_start_date}. You can find more information about your options during open enrollment at: <a href=\"http://www.MAhealthconnector.org\">www.MAhealthconnector.org</a>.</p>\r\n\r\n<h3><strong>You DO NOT Currently Have a Plan</strong></h3>\r\n\r\n<p>You chose to waive coverage last year or did not take any action. &nbsp;If you would like to enroll in coverage for this year you must select a plan by \#{employee_profile.plan_year.renewal_py_oe_end_date} in order to have coverage effective \#{employee_profile.plan_year.renewal_py_start_date}. &nbsp;</p>\r\n\r\n<p>If you do not wish to receive coverage through \#{employee_profile.employer_name} you should go into your Health Connector account and &ldquo;waive&rdquo; coverage for the upcoming plan year</p>\r\n\r\n<h3><strong>What is Open Enrollment?</strong></h3>\r\n\r\n<p>Open enrollment is your annual opportunity to enroll in health plans offered by your employer or make changes to your current plan selection. &nbsp;Outside of this annual open enrollment period, you will only be allowed to make changes to your enrollment if you experience certain life events, such as marriage, birth, or adoption, or other qualifying events.</p>\r\n\r\n<h3><strong>To See Plan Options and Enroll:</strong></h3>\r\n\r\n<p>Please log-in to your existing account or create an account on <a href=\"http://www.MAhealthconnector.org\">www.MAhealthconnector.org</a> to view your plan options and complete the enrollment process.&nbsp;</p>\r\n\r\n<h3><strong>For Questions or Assistance:</strong></h3>\r\n\r\n<p>[[ if employee_profile.broker_present? ]]</p>\r\n\r\n<p>Please contact your employer or your broker for further assistance.</p>\r\n\r\n<p>[[ else ]]</p>\r\n\r\n<p>Please contact your employer for further assistance.<br />\r\n[[ end ]]</p>\r\n\r\n<p>You can also contact the Health Connector with any questions:</p>\r\n\r\n<ul>\r\n\t<li>By calling \#{Settings.contact_center.phone_number}. TTY: \#{Settings.contact_center.tty_number}</li>\r\n\t<li>By email: <a href=\"mailto:\#{Settings.contact_center.small_business_email}\">\#{Settings.contact_center.small_business_email}</a></li>\r\n</ul>\r\n\r\n<p>You can also find more information on our website at <a href=\"http://​\#{Settings.site.main_web_address}\">\#{Settings.site.main_web_address}</a></p>\r\n\r\n<p>[[ if employee_profile.broker_present? ]]</p>\r\n\r\n<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"height:auto; width:auto\">\r\n\t<tbody>\r\n\t\t<tr>\r\n\t\t\t<td><strong>Broker: &nbsp;&nbsp;</strong></td>\r\n\t\t\t<td>\#{employee_profile.broker.primary_fullname}</td>\r\n\t\t</tr>\r\n\t\t<tr>\r\n\t\t\t<td>&nbsp;</td>\r\n\t\t\t<td>\#{employee_profile.broker.organization}</td>\r\n\t\t</tr>\r\n\t\t<tr>\r\n\t\t\t<td>&nbsp;</td>\r\n\t\t\t<td>\#{employee_profile.broker.phone}</td>\r\n\t\t</tr>\r\n\t\t<tr>\r\n\t\t\t<td>&nbsp;</td>\r\n\t\t\t<td>\#{employee_profile.broker.email}</td>\r\n\t\t</tr>\r\n\t</tbody>\r\n</table>\r\n\r\n<p>[[ end ]]</p>\r\n\r\n<p>___________________________________________________________________________________________________________________________________________________</p>\r\n\r\n<p><small>This notice is being provided in accordance with 45 C.F.R. 155.725(f).</small></p>\r\n"}}

      let!(:mock_template) { Template.new(data)}
      let!(:notice_kind) { FactoryGirl.build(:notifier_notice_kind, template: mock_template ) }
      let!(:notice_kind_no_template) { FactoryGirl.build(:notifier_notice_kind) }

      let(:params) { %w(employee_profile.notice_date employee_profile.first_name employee_profile.last_name employee_profile.employer_name employee_profile.plan_year.renewal_py_oe_start_date employee_profile.plan_year.renewal_py_oe_end_date employee_profile.plan_year.renewal_py_start_date employee_profile.broker.primary_fullname employee_profile.broker.organization employee_profile.broker.phone employee_profile.broker.email employee_profile.broker_present?)}

      context 'saving the notice_kind record with valid template data elements' do

        it 'should be able to parse the raw_body' do
          expect(mock_template.data_elements).to eq []
          notice_kind.set_data_elements
          expect(mock_template.data_elements).to eq params
        end

        it 'should not be able to save template data elements' do
          expect(notice_kind_no_template.template).to be_nil
          notice_kind.set_data_elements
          expect(notice_kind_no_template.template).to be_nil
        end
      end
    end


    describe '.execute_notice' do
      context 'generating notice with attached envelopes' do
        let!(:notice_kind) {  FactoryGirl.build(:notifier_notice_kind) }
        let!(:pay_load) { {'employee_role_id'=> 'rspec-role-id',
                           'event_object_kind' => 'rspec-kind',
                           'event_object_id' => 'rspec-object-id'
        } }
        let!(:event_name) { 'acapi.info.events.employee.rspec'}
        let!(:unmapped_event_name) { 'acapi.info.events.brokeragency.rspec' }

        it 'should be able to generate and attach envelopes' do
          allow(EmployeeRole).to receive(:send).with(:find, 'rspec-role-id').and_return('rspec-resource')
          expect_any_instance_of(Notifier::NoticeBuilder).to receive(:generate_pdf_notice).and_return(true)
          expect_any_instance_of(Notifier::NoticeBuilder).to receive(:upload_and_send_secure_message).and_return(true)
          expect_any_instance_of(Notifier::NoticeBuilder).to receive(:send_generic_notice_alert).and_return(true)
          notice_kind.execute_notice(event_name, pay_load)
        end

        it 'should be able to raise the error when no mapping' do
          expect { notice_kind.execute_notice(unmapped_event_name, pay_load) }.to raise_error ArgumentError
        end

        it 'should be able to raise error when no resource' do
          allow(EmployeeRole).to receive(:send).with(:find, 'rspec-role-id').and_return(nil)
          expect { notice_kind.execute_notice(event_name, pay_load) }.to raise_error ArgumentError
        end

      end
    end


    describe '.recipient_klass_name' do
      let!(:notice_kind) { FactoryGirl.build(:notifier_notice_kind) }
      it 'should be able to return class name' do
        expect(notice_kind.recipient_klass_name).to eq :employer_profile
      end
    end

    describe 'model state transisitions' do
      let!(:notice_instance) { FactoryGirl.build(:notifier_notice_kind) }

      it 'validate state transitions' do
        expect(notice_instance).to have_state(:draft)
        expect(notice_instance).not_to have_state(:published)
        expect(notice_instance).not_to have_state(:archived)
        expect(notice_instance).not_to allow_event(:publish)
        expect(notice_instance).to transition_from(:published).to(:archived).on_event(:archive)
      end
    end

    describe '.record_transition' do
      let!(:notice_kind) { FactoryGirl.build(:notifier_notice_kind, aasm_state: 'published') }
      let!(:wst_instance) { WorkflowStateTransition.new }

      it 'should invoke record_transition method on event triggered' do
         allow(WorkflowStateTransition).to receive(:new).with(from_state: :published, to_state: :archived).and_return(wst_instance)
         notice_kind.archive! if notice_kind.may_archive?
         expect(notice_kind.workflow_state_transitions).to eq [wst_instance]
      end
    end
  end
end

