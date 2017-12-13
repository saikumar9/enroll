require "rails_helper"

RSpec.describe "broker_agencies/profiles/edit.html.erb" do
  let(:organization) { FactoryBot.create(:organization) }
  let(:broker_agency_profile) { FactoryBot.create(:broker_agency_profile, organization: organization) }
  let(:user) { create(:user, :hbx_staff) }
  before :each do
    org_form = Forms::BrokerAgencyProfile.find(broker_agency_profile.id)
    allow(controller).to receive(:current_user) { user }
    assign :organization, org_form
    assign :broker_agency_profile, broker_agency_profile
    assign :id, broker_agency_profile.id
    assign :provider, FactoryBot.create(:person)
    render template: "broker_agencies/profiles/edit.html.erb"
  end

  it "should have title" do
    expect(rendered).to have_selector('h4', text: 'Personal Information')
    expect(rendered).to have_selector('h4', text: 'Broker Agency Information')
  end
  it "should block the market kind dropdown refs #9818" do
    expect(rendered).to have_selector('.broker-agency-info.read_only_dropdown')
  end
  it "should have two read only fields refs #9818"  do
    expect(rendered).to have_selector("[readonly='readonly']", count: 2)
  end
  it "should have a hidden field refs #6724" do
    expect(rendered).to have_selector('div.hidden_field', count: 1)
  end
end
