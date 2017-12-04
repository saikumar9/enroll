require 'rails_helper'

describe Address, "with proper validations" do
  let(:address_kind) { "home" }
  let(:address_1) { "1 Clear Crk" }
  let(:city) { "Irvine" }
  let(:state) { "CA" }
  let(:zip) { "20171" }

  let(:address_params) {
    {
      kind: address_kind,
      address_1: address_1,
      city: city,
      state: state,
      zip: zip
    }
  }
  subject { Address.new(address_params) }

  before :each do
    subject.valid?
  end

  context "embedded in another object", type: :model do
    it { should validate_presence_of :address_1 }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }

    let(:person) {Person.new(first_name: "John", last_name: "Doe", gender: "male", dob: "10/10/1974", ssn: "123456789" )}
    let(:address) {FactoryBot.create(:address)}
    let(:employer){FactoryBot.create(:employer_profile)}


    context "accepts all valid values" do
      let(:params) { address_params.except(:kind)}
      it "should save the address" do
        ['home', 'work', 'mailing'].each do |type|
          params.deep_merge!({kind: type})
          address = Address.new(**params)
          person.addresses << address
          expect(address.errors[:kind].any?).to be_falsey
          expect(address.valid?).to be_truthy
        end
      end
    end
  end
end