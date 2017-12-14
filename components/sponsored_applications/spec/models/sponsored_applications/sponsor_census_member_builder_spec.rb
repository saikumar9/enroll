require 'rails_helper'

module SponsoredApplications
  RSpec.describe 'Load sponsor members from census members', dbclean: :after_each do
    let(:subject) { SponsorCensusMemberBuilder.new([census_member]) }

    context "given an array of census employees" do
      let(:census_member) { create(:census_employee) }

      it "can return a SponsorCensusMember given a CensusMember" do
        expect(subject.sponsor_census_members.first).to be_kind_of(SponsorCensusMember)
        expect(subject.sponsor_census_members.first.full_name).to eq(census_member.full_name)
      end

      it "can return a CensusMember from its SponsorCensusMembers if they have ssn" do
        members = subject.build_census_members_from_sponsor_members
        expect(members.first).to be_kind_of(CensusMember)
        expect(members.first.full_name).to eq(census_member.full_name)
      end
    end

    context "given CensusMembers with dependents" do
      let(:census_member) { create(:census_employee, create_with_spouse: true) }

      it "creates dependents along with the census member" do
        result = subject.sponsor_census_members.first
        expect(result).to be_kind_of(SponsorCensusMember)
        expect(result.full_name).to eq(census_member.full_name)
        expect(result.census_dependents.count).to eq(1)
        expect(result.census_dependents.first).to be_kind_of(SponsorCensusDependent)
      end
    end

  end
end
