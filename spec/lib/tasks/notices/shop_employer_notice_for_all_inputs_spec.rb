require 'rails_helper'
Rake.application.rake_require "tasks/notices/shop_employer_notice_for_all_inputs"
include ActiveJob::TestHelper
Rake::Task.define_task(:environment)

RSpec.describe 'Generate notices to employer by taking hbx_ids, feins, employer_ids and event name', :type => :task do
  let!(:employer_profile) { double(:employer_profile, id: "rspec-id" ) }
  let!(:organization) { double(:organization, employer_profile: employer_profile, hbx_id: "1231") }
  let!(:organization_hbx) { double(:organization, employer_profile: employer_profile,  hbx_id: "131323") }
  let!(:organization_feins) { double(:organization,  employer_profile: employer_profile, fein: "987") }

  before :each do
   $stdout = StringIO.new

   allow(ShopNoticesNotifierJob).to receive(:perform_later).and_return(true)
  end

  after(:each) do
    Rake::Task['notice:shop_employer_notice_event'].reenable
  end

  after(:all) do
    $stdout = STDOUT
  end

  context "should not Trigger notice" do
    it "When event name is not specified" do
      allow(EmployerProfile).to receive(:find).with(employer_profile.id).and_return(employer_profile)
      Rake::Task["notice:shop_employer_notice_event"].invoke(event: nil, employer_ids: employer_profile.id)
      expect(ShopNoticesNotifierJob).to have_received(:perform_later).exactly(0).times
    end
  end

  context "Trigger Notice for 2 employers" do
    before do
      allow(Organization).to receive(:where).with(hbx_id: "1231").and_return(organization)
      allow(Organization).to receive(:where).with(hbx_id: "131323").and_return(organization_hbx)
      allow(organization).to receive_message_chain("first.employer_profile") { employer_profile }
      allow(organization_hbx).to receive_message_chain("first.employer_profile") { employer_profile }
      Rake::Task["notice:shop_employer_notice_event"].invoke(event: 'rspec-event', hbx_ids: '1231 131323')
    end
    it "when multiple hbx_ids input is given" do
      expect(ShopNoticesNotifierJob).to have_received(:perform_later).exactly(2).times
    end
  end

  context "Trigger Notice" do
    before do
      allow(Organization).to receive(:where).with(fein: "987").and_return(organization_feins)
      allow(organization_feins).to receive_message_chain("first.employer_profile") { employer_profile }
      Rake::Task["notice:shop_employer_notice_event"].invoke(event: 'rspec-event', feins: '987')
    end
    it "When organization fein is given" do
      expect(ShopNoticesNotifierJob).to have_received(:perform_later).exactly(1).times
    end
  end

  context " Trigger Notice " do
    before do
      allow(Organization).to receive(:where).with(hbx_id: "1231").and_return(organization)
      allow(organization).to receive_message_chain("first.employer_profile") { employer_profile }
      Rake::Task["notice:shop_employer_notice_event"].invoke(event: 'rspec-event', feins: '123123', hbx_ids: '1231')
    end
    it "only once when fein and hbx_id is given" do
      expect(ShopNoticesNotifierJob).to have_received(:perform_later).exactly(1).times
    end
  end
end
