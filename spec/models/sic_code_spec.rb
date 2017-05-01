require 'rails_helper'

RSpec.describe SicCode, type: :model do 
	subject{SicCode.new}
  let(:test10) {FactoryGirl.create(:sic_code)}

  it "has valid SIC code" do
    p test10
    expect(build(:sic_code).valid?).to be_truthy
  end

  it "has an invalid SIC code" do
    expect(build(:sic_code, sic: nil).valid?).to be_falsy
  end

  it "has valid SIC code and invalid description" do
    expect(build(:sic_code, sic: "0172", description: nil).valid?).to be_falsy
  end

  it "has Invalid SIC and valid Desc" do
    expect(build(:sic_code, sic: nil, description: "Grapes").valid?).to be_falsy
  end
end
