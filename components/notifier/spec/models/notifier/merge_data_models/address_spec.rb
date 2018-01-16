require 'rails_helper'

module Notifier
  RSpec.describe MergeDataModels::Address, type: :model do

    describe MergeDataModels::Address, "with proper validations" do
      context "with valid arguments on factory" do
        let(:address)  {  FactoryGirl.build :notifier_merge_data_models_address }
        let(:address_params) {
          {
            street_1: address.street_1,
            street_2: address.street_2,
            city: address.city,
            state: address.state,
            zip: address.zip
          }
        }

        it "should be valid" do
          ['street_1', 'street_2', 'city', 'state', 'zip'].each do |type|
            expect(address[type]).to eq address_params[type.to_sym]
          end
        end
      end

      context "with valid arguments on creating new object" do
        let(:merge_object) { Notifier::MergeDataModels::Address.new }
        it "should be valid" do
          ['street_1', 'street_2', 'city', 'state', 'zip'].each do |type|
            expect(merge_object[type]).to eq merge_object[type.to_sym]
          end
        end
      end
    end

    describe "#stubbed_object" do 
      let(:stubbed_object) { Notifier::MergeDataModels::Address.stubbed_object}

      it 'returns self' do
        klass = Class.new { include Virtus }
        ['street_1', 'street_2', 'city', 'state', 'zip'].each do |type|
          expect(klass.attribute(stubbed_object[type.to_sym])).to be(klass)
        end
      end

      it 'an object with string attribute' do
        expect(stubbed_object.attributes.keys).to eq [:street_1, :street_2, :city, :state, :zip]
      end
    end
  end
end