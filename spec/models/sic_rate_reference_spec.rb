require 'rails_helper'

describe SicRateReference, "with proper validations" do
  let(:sic) { "0111" }
  let(:hios_id) { "82569" }
  let(:cost_ratio) { 1.000 }
  let(:applicable_year) { 2017 }
  

  let(:sic_rate_reference_params) {
    {
      sic: sic,
      hios_id: hios_id,
      cost_ratio: cost_ratio,
      applicable_year: applicable_year
    }
  }

  subject { SicRateReference.new(sic_rate_reference_params) }

  before :each do
    subject.valid?
  end

  context "with no arguments" do
    let(:sic_rate_reference_params) { {} }
    it "should not be valid" do
      expect(subject.valid?).to be_falsey
    end
  end

  context "with empty sic" do
    let(:sic) { nil }
    it "is not a valid sic rate reference" do
      expect(subject.errors[:sic].any?).to be_truthy
    end
  end

  context "with no hios_id" do
    let(:hios_id) { nil }
    it "is not a valid sic rate reference" do
      expect(subject.errors[:hios_id].any?).to be_truthy
    end
  end

  context "with no cost_ratio" do
    let(:cost_ratio) { nil }
    it "is not a valid sic rate reference" do
      expect(subject.errors[:cost_ratio].any?).to be_truthy
    end
  end

  context "with no applicable_year" do
    let(:applicable_year) { nil }
    it "is not valid sic rate reference" do
      expect(subject.errors[:applicable_year].any?).to be_truthy
    end
  end

end