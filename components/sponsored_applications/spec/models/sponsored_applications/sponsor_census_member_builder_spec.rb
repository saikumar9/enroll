require 'rails_helper'

RSpec.describe 'Load sponsor members from census members', dbclean: :after_each do
  context "given a census employees" do
    let!(:census_member) { create(:census_employee_with_benefit_group) }

    let(:subject) { SponsorCensusMemberBuilder.new([census_member]) }

    it "can return a SponsorCensuMember" do
      expect(subject.sponsor_census_members.first.full_name).to eq(census_member.full_name)
    end
  end
end
