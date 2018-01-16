require 'rails_helper'

module Notifier
  RSpec.describe MergeDataModels::Broker, type: :model do

    describe MergeDataModels::Broker, "with proper validations" do
      context "with valid arguments on factory" do
        let(:broker)  {  FactoryGirl.build :notifier_merge_data_models_broker }
        let(:address)  {  FactoryGirl.build :notifier_merge_data_models_address }
        let(:broker_params) {
          {
            primary_fullname: broker.primary_fullname,
            organization: broker.organization,
            address: address,
            phone: broker.phone,
            email: broker.email,
            web_address: broker.web_address
          }
        }

        it "should be valid" do
          ['primary_fullname', 'organization', 'phone', 'email', 'web_address'].each do |type|
            expect(broker[type]).to eq broker_params[type.to_sym]
          end
        end
      end

      context "with valid arguments on creating new object" do
        let(:merge_object) { Notifier::MergeDataModels::Broker.new }
        it "should be valid" do
          ['primary_fullname', 'organization', 'phone', 'email', 'web_address'].each do |type|
            expect(merge_object[type]).to eq merge_object[type.to_sym]
          end  
        end

        it 'should match address key' do
          expect(merge_object.attributes).to have_key(:address)
        end
      end
    end

    describe "#stubbed_object" do 
      let(:stubbed_object) { Notifier::MergeDataModels::Broker.stubbed_object}

      it 'returns self' do
        klass = Class.new { include Virtus }
        ['primary_fullname', 'organization', 'phone', 'email', 'web_address'].each do |type|
          expect(klass.attribute(stubbed_object[type.to_sym])).to be(klass)
        end
      end

      it 'an object with string attribute' do
        expect(stubbed_object.attributes.keys).to eq [:primary_fullname, :organization, :address, :phone, :email, :web_address]
      end
    end
  end
end