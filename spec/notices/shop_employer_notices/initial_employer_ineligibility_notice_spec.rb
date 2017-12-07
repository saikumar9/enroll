require 'rails_helper'

RSpec.describe ShopEmployerNotices::InitialEmployerIneligibilityNotice do
  let(:start_on) {
    effective_date = TimeKeeper.date_of_record.beginning_of_month + 1.month - 1.year
    if effective_date.yday == 1
      effective_date + 1.month
    else
      effective_date
    end
  }
  let!(:employer_profile){ create :employer_profile}
  let!(:person){ create :person}
  let!(:plan_year) { FactoryBot.create(:plan_year, employer_profile: employer_profile, start_on: start_on, :aasm_state => 'active' ) }
  let!(:active_benefit_group) { FactoryBot.create(:benefit_group, plan_year: plan_year, title: "Benefits #{plan_year.start_on.year}") }
  let!(:renewal_plan_year) { FactoryBot.create(:plan_year, employer_profile: employer_profile, start_on: start_on + 1.year, :aasm_state => 'application_ineligible' ) }
  let!(:renewal_benefit_group) { FactoryBot.create(:benefit_group, plan_year: renewal_plan_year, title: "Benefits #{plan_year.start_on.year}") }
  let(:application_event){ double("ApplicationEventKind",{
                            :name =>'Initial Group Ineligible to Obtain Coverage',
                            :notice_template => 'notices/shop_employer_notices/20_a_initial_employer_ineligibility_notice',
                            :notice_builder => 'ShopEmployerNotices::InitialEmployerIneligibilityNotice',
                            :event_name => 'initial_employer_ineligibility_notice',
                            :mpi_indicator => 'SHOP_M020',
                            :title => "Group Ineligible to Obtain Coverage"})
                          }
    let(:valid_parmas) {{
        :subject => application_event.title,
        :mpi_indicator => application_event.mpi_indicator,
        :event_name => application_event.event_name,
        :template => application_event.notice_template
    }}

  describe "New" do
    before do
      allow(employer_profile).to receive_message_chain("staff_roles.first").and_return(person)
    end
    context "valid params" do
      it "should initialze" do
        expect{ShopEmployerNotices::InitialEmployerIneligibilityNotice.new(employer_profile, valid_parmas)}.not_to raise_error
      end
    end

    context "invalid params" do
      [:mpi_indicator,:subject,:template].each do  |key|
        it "should NOT initialze with out #{key}" do
          valid_parmas.delete(key)
          expect{ShopEmployerNotices::InitialEmployerIneligibilityNotice.new(employer_profile, valid_parmas)}.to raise_error(RuntimeError,"Required params #{key} not present")
        end
      end
    end
  end

  describe "Build" do
    before do
      allow(employer_profile).to receive_message_chain("staff_roles.first").and_return(person)
      @employer_notice = ShopEmployerNotices::InitialEmployerIneligibilityNotice.new(employer_profile, valid_parmas)
    end
    it "should build notice with all necessary info" do
      @employer_notice.build
      expect(@employer_notice.notice.primary_fullname).to eq person.full_name.titleize
      expect(@employer_notice.notice.employer_name).to eq employer_profile.organization.legal_name
      expect(@employer_notice.notice.primary_identifier).to eq employer_profile.hbx_id
    end
  end

  describe "append_data" do
    before do
      allow(employer_profile).to receive_message_chain("staff_roles.first").and_return(person)
      @employer_notice = ShopEmployerNotices::InitialEmployerIneligibilityNotice.new(employer_profile, valid_parmas)
    end
    it "should append necessary information" do
      @employer_notice.append_data
      expect(@employer_notice.notice.plan_year.start_on).to eq plan_year.start_on
      expect(@employer_notice.notice.plan_year.open_enrollment_end_on).to eq plan_year.open_enrollment_end_on
      expect(@employer_notice.notice.plan_year.end_on).to eq plan_year.end_on
      expect(@employer_notice.notice.plan_year.warnings).to eq ["At least 75% of your eligible employees enrolled in your group health coverage or waive due to having other coverage."]
    end
  end

end
