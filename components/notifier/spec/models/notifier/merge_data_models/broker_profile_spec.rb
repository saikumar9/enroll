require 'rails_helper'

module Notifier
  RSpec.describe MergeDataModels::BrokerProfile, type: :model do

    describe MergeDataModels::BrokerProfile, "with proper validations" do
      context "with valid arguments on factory" do
        let(:broker_profile)  {  FactoryGirl.build :notifier_merge_data_models_broker_profile }
        let(:mailing_address)  {  FactoryGirl.build :notifier_merge_data_models_address }
        let(:broker_profile_params) {
          {
            notice_date: broker_profile.notice_date,
            first_name: broker_profile.first_name,
            last_name: broker_profile.last_name,
            mailing_address: mailing_address,
            broker_agency_name: broker_profile.broker_agency_name,
            assignment_date: broker_profile.assignment_date,
            employer_name: broker_profile.employer_name,
            employer_poc_firstname: broker_profile.employer_poc_firstname,
            employer_poc_lastname: broker_profile.employer_poc_lastname
          }
        }

        it "should be valid" do
          ['notice_date', 'first_name', 'last_name', 'broker_agency_name', 'assignment_date', 'employer_name', 'employer_poc_firstname', 'employer_poc_lastname'].each do |type|
            expect(broker_profile[type]).to eq broker_profile_params[type.to_sym]
          end
        end
      end

      context "with valid arguments on creating new object" do
        let(:merge_object) { Notifier::MergeDataModels::BrokerProfile.new }
        it "should be valid" do
          ['notice_date', 'first_name', 'last_name', 'broker_agency_name', 'assignment_date', 'employer_name', 'employer_poc_firstname', 'employer_poc_lastname'].each do |type|
            expect(merge_object[type]).to eq merge_object[type.to_sym]
          end  
        end

        it 'should match address key' do
          expect(merge_object.attributes).to have_key(:mailing_address)
        end
      end
    end

    describe "#stubbed_object" do 
      let(:stubbed_object) { Notifier::MergeDataModels::BrokerProfile.stubbed_object}

      it 'returns self' do
        klass = Class.new { include Virtus }
        ['notice_date', 'first_name', 'last_name', 'broker_agency_name', 'assignment_date', 'employer_name', 'employer_poc_firstname', 'employer_poc_lastname'].each do |type|
          expect(klass.attribute(stubbed_object[type.to_sym])).to be(klass)
        end
      end

      it 'an object with string attribute' do
        expect(stubbed_object.attributes.keys).to eq [:notice_date, :first_name, :last_name, :mailing_address, :broker_agency_name, :assignment_date, :employer_name, :employer_poc_firstname, :employer_poc_lastname]
      end
    end
  end
end