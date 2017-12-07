require 'rails_helper'

RSpec.describe CarrierProfile, :type => :model, dbclean: :after_each do

  let(:organization) {FactoryBot.create(:organization)}

  describe "class methods" do
    context "carrier_profile_service_area_pairs_for" do
      let!(:carrier_profile) { create(:carrier_profile, with_service_areas: 0, issuer_hios_ids: ['99999']) }
      let!(:carrier_service_area_2017) { create(:carrier_service_area, issuer_hios_id: carrier_profile.issuer_hios_ids.first, active_year: '2017') }
      let!(:carrier_service_area_2018) { create(:carrier_service_area, issuer_hios_id: carrier_profile.issuer_hios_ids.first, active_year: '2018') }
      let!(:employer) { create(:employer_profile) }

      it "should return the appropriate service area based on year" do
        expect(CarrierProfile.carrier_profile_service_area_pairs_for(employer, '2017' )).to contain_exactly([carrier_profile.id, carrier_service_area_2017.service_area_id])
        expect(CarrierProfile.carrier_profile_service_area_pairs_for(employer, '2018' )).to contain_exactly([carrier_profile.id, carrier_service_area_2018.service_area_id])
      end
    end
  end
end
