require 'rails_helper'

module Notifier
  RSpec.describe MergeDataModels::EmployerProfile, type: :model do

    describe 'model attributes' do
      subject { Notifier::MergeDataModels::EmployerProfile.new }
      it { expect(described_class.attributes).to be_instance_of(Virtus::AttributeSet)
      expect(described_class.attributes[:notice_date]).to be_instance_of(Virtus::Attribute)
      expect(described_class.attribute_set[:notice_date].primitive).to be String
      expect(described_class).to have_attribute(:notice_date).of_type(String)
      expect(described_class).to have_attribute(:first_name).of_type(String)
      expect(described_class).to have_attribute(:last_name).of_type(String)
      expect(described_class).to have_attribute(:application_date).of_type(String)
      expect(described_class).to have_attribute(:invoice_month).of_type(String)
      expect(described_class).to have_attribute(:employer_name).of_type(String)
      expect(described_class).to have_attribute(:mailing_address).of_type(MergeDataModels::Address)
      expect(described_class).to have_attribute(:broker).of_type(MergeDataModels::Broker)
      expect(described_class).to have_attribute(:plan_year).of_type(MergeDataModels::PlanYear)
      expect(described_class).to have_attribute(:addresses).of_type(Array, member_type: MergeDataModels::Address)
      }
    end

    describe 'model constant' do
      it 'should include valid model constant values' do
        expect(Notifier::MergeDataModels::EmployerProfile::DATE_ELEMENTS).to include "current_py_start_on"
        expect(Notifier::MergeDataModels::EmployerProfile::DATE_ELEMENTS).to include "current_py_end_on"
        expect(Notifier::MergeDataModels::EmployerProfile::DATE_ELEMENTS).to include "renewal_py_start_on"
        expect(Notifier::MergeDataModels::EmployerProfile::DATE_ELEMENTS).to include "renewal_py_end_on"
      end
    end

    describe 'validate facotry' do
      let!(:merge_data_models_employer_profile) { FactoryGirl.build(:notifier_merge_data_models_employer_profile) }

      it 'should have valid model attributes' do
        expect(merge_data_models_employer_profile.attributes.keys).to eq  [:notice_date, :first_name, :last_name, :application_date, :invoice_month, :employer_name, :mailing_address, :broker, :plan_year, :addresses]
        hash_attributes = merge_data_models_employer_profile.attributes
        hash_attributes.each do |k, v|
          expect(hash_attributes[k]).to be_nil unless k == :addresses
        end
        expect(hash_attributes[:addresses]).to eq []
      end
    end

    describe '#stubbed_object' do
      it 'should return preview template elements ' do
        value = Notifier:: MergeDataModels::EmployerProfile.stubbed_object
        expect(value.mailing_address).not_to be_nil
        expect(value.mailing_address).to be_kind_of(Notifier::MergeDataModels::Address)
        expect(value.plan_year).not_to be_nil
        expect(value.plan_year).to be_kind_of(Notifier::MergeDataModels::PlanYear)
        expect(value.broker).not_to be_nil
        expect(value.broker).to be_kind_of(Notifier::MergeDataModels::Broker)
        expect(value.addresses).not_to be_nil
        expect(value.addresses).to eq [value.mailing_address]
      end
    end
  end
end
