require 'rails_helper'

module DataTablesAdapter
end
module Config::AcaConcern
end

module SponsoredBenefits
  RSpec.describe Organizations::PlanDesignOrganizationsController, type: :controller, dbclean: :around_each  do
    routes { SponsoredBenefits::Engine.routes }

    let(:valid_session) { {} }
    let(:current_person) { double(:current_person) }
    let(:employer) { double(:employer, id: "11111", name: 'ABC Company', sic_code: '0197') }
    let(:broker) { double(:broker, id: 2) }
    let(:broker_role) { double(:broker_role, id: 3) }
    let(:broker_agency_profile) { double(:sponsored_benefits_broker_agency_profile, id: "3123", persisted: true, fein: "5555", hbx_id: "123312",
                                    legal_name: "ba-name", dba: "alternate", is_active: true, organization: plan_design_organization()) }
    let(:old_broker_agency_profile) { build(:sponsored_benefits_broker_agency_profile) }
    let!(:plan_design_organization) { create(:plan_design_organization, customer_profile_id: employer.id,
                                                                        owner_profile_id: '22222',
                                                                        legal_name: employer.name,
                                                                        sic_code: employer.sic_code ) }
    let(:user) { double(:user) }
    let(:datatable) { double(:datatable) }
    let(:sic_codes) { double(:sic_codes) }

    before do
      allow(subject).to receive(:current_person).and_return(current_person)
      allow(current_person).to receive(:broker_role).and_return(broker_role)
      allow(broker_role).to receive(:broker_agency_profile_id).and_return(broker_agency_profile.id)
      allow(subject).to receive(:init_datatable).and_return(datatable)
    end

    context "GET #employers" do
      it "returns a success response" do
        xhr :get, :employers, { plan_design_organization_id: plan_design_organization.id }, valid_session
        expect(response).to be_success
      end
    end

    describe "GET #new" do
      before do
        allow(subject).to receive(:init_organization).and_return(plan_design_organization)
      end

      it "returns a success response" do
        get :new, { plan_design_organization_id: plan_design_organization.id }, valid_session
        expect(response).to be_success
      end
    end

    describe "GET #edit" do
      before do
        allow(subject).to receive(:get_sic_codes).and_return(sic_codes)
      end

      it "returns a success response" do
        get :edit, { id: plan_design_organization.to_param }, valid_session
        expect(response).to be_success
      end
    end

    describe "POST #create" do
      before do
        allow(BrokerAgencyProfile).to receive(:find).with(broker_agency_profile.id).and_return(broker_agency_profile)
        allow(SponsoredBenefits::Organizations::BrokerAgencyProfile).to receive(:find_or_initialize_by).with(:fein).and_return("223232323")
      end

      let(:valid_attributes) {
        {
          "legal_name"  =>  "Some Name",
          "dba"         =>  "",
          "entity_kind" =>  "",
          "sic_code"    =>  "0116",
          "office_locations_attributes" =>
                {"0"=>
                    { "address_attributes" =>
                        { "kind"      =>  "primary",
                          "address_1" =>  "",
                          "address_2" =>  "",
                          "city"      =>  "",
                          "state"     =>  "",
                          "zip"       =>  "01001",
                          "county"    =>  "Hampden"
                        },
                      "phone_attributes" =>
                        { "kind"      =>  "phone main",
                          "area_code" =>  "",
                          "number"    =>  "",
                          "extension" =>  ""
                        }
                    }
          },
          "broker_agency_id" => broker_agency_profile.id
        }
      }

      let(:invalid_attributes) {
        {
          "legal_name"  =>  "Some Name"
        }
      }

      context "with valid params" do
        it "creates a new Organizations::PlanDesignOrganization" do
          expect {
            post :create, { organization: valid_attributes, broker_agency_id: broker_agency_profile.id, format: 'js'}, valid_session
          }.to change { Organizations::PlanDesignOrganization.all.count }.by(1)
        end

        it "renders the create view" do
          post :create, { organization: valid_attributes, broker_agency_id: broker_agency_profile.id, format: 'js'}, valid_session
          expect(response).to render_template(:create)
        end
      end

      context "with invalid params" do
        before do
          allow(subject).to receive(:init_organization).and_return(plan_design_organization)
        end

        it "creates a new Organizations::PlanDesignOrganization" do
          expect {
            post :create, { organization: invalid_attributes, broker_agency_id: broker_agency_profile.id, format: 'js'}, valid_session
          }.to change { Organizations::PlanDesignOrganization.all.count }.by(0)
        end

        it "renders the new view" do
          post :create, { organization: invalid_attributes, broker_agency_id: broker_agency_profile.id, format: 'js'}, valid_session
          expect(response).to render_template(:new)
        end
      end
    end

    describe "PATCH #update" do
      before do
        allow(BrokerAgencyProfile).to receive(:find).with(broker_agency_profile.id).and_return(broker_agency_profile)
        allow(SponsoredBenefits::Organizations::BrokerAgencyProfile).to receive(:find_or_initialize_by).with(:fein).and_return("223232323")
      end

      let(:valid_attributes) {
        {
          "legal_name"  =>  "Some New Name",
        }
      }

      let(:invalid_attributes) {
        {
          "legal_name"  =>  nil
        }
      }

      context "with valid params" do
        it "updates Organizations::PlanDesignOrganization" do
          expect {
            patch :update, { organization: valid_attributes, id: plan_design_organization.id, format: 'js' }, valid_session
          }.to change { plan_design_organization.reload.legal_name }.to('Some New Name')
        end

        it "renders the update view" do
          patch :update, { organization: valid_attributes, id: plan_design_organization.id, format: 'js' }, valid_session
          expect(response).to render_template(:update)
        end

        it "does not create a new Organizations::PlanDesignOrganization" do
          expect {
            patch :update, { organization: valid_attributes, id: plan_design_organization.id, format: 'js'}, valid_session
          }.to change { Organizations::PlanDesignOrganization.all.count }.by(0)
        end
      end

      context "with invalid params" do
        it "does not update Organizations::PlanDesignOrganization" do
          expect {
            patch :update, { organization: invalid_attributes, id: plan_design_organization.id, format: 'js' }, valid_session
          }.not_to change { plan_design_organization.reload.legal_name }
        end

        it "renders the update view" do
          patch :update, { organization: invalid_attributes, id: plan_design_organization.id, format: 'js' }, valid_session
          expect(response).to render_template(:edit)
        end
      end
    end
  end
end