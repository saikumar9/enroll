require 'rails_helper'

module Notifier
  RSpec.describe MergeDataModels::EmployeeProfile, type: :model do
    
    describe "with proper attributes" do
      it { expect(described_class.attributes).to be_instance_of(Virtus::AttributeSet)
      expect(described_class.attributes[:notice_date]).to be_instance_of(Virtus::Attribute)
      expect(described_class.attribute_set[:notice_date].primitive).to be String
      expect(described_class).to have_attribute(:notice_date).of_type(String)
      expect(described_class).to have_attribute(:first_name).of_type(String)
      expect(described_class).to have_attribute(:last_name).of_type(String)
      expect(described_class).to have_attribute(:employer_name).of_type(String)
      expect(described_class).to have_attribute(:date_of_hire).of_type(String)
      expect(described_class).to have_attribute(:earliest_coverage_begin_date).of_type(String)
      expect(described_class).to have_attribute(:new_hire_oe_start_date).of_type(String)
      expect(described_class).to have_attribute(:new_hire_oe_end_date).of_type(String)
      expect(described_class).to have_attribute(:mailing_address).of_type(MergeDataModels::Address)
      expect(described_class).to have_attribute(:broker).of_type(MergeDataModels::Broker)
      expect(described_class).to have_attribute(:plan_year).of_type(MergeDataModels::PlanYear)
      expect(described_class).to have_attribute(:addresses).of_type(Array, member_type: MergeDataModels::Address)
      }
    end

    describe "with proper validations" do
      let(:employee_profile)  {  FactoryGirl.build :notifier_merge_data_models_employee_profile }
      let(:mailing_address)  {  FactoryGirl.build :notifier_merge_data_models_address }
      
      context "with valid arguments on factory" do
        let(:employee_profile_params) {
          {
            notice_date: employee_profile.notice_date,
            first_name: employee_profile.first_name,
            last_name: employee_profile.last_name,
            mailing_address: mailing_address,
            employer_name: employee_profile.employer_name,
            date_of_hire: employee_profile.date_of_hire,
            earliest_coverage_begin_date: employee_profile.earliest_coverage_begin_date,
            new_hire_oe_start_date: employee_profile.new_hire_oe_start_date,
            new_hire_oe_end_date: employee_profile.new_hire_oe_end_date
          }
        }

        it "should be valid" do
          ['notice_date', 'first_name', 'last_name', 'employer_name', 'date_of_hire', 'earliest_coverage_begin_date', 'new_hire_oe_start_date', 'new_hire_oe_end_date'].each do |type|
            expect(employee_profile[type]).to eq employee_profile_params[type.to_sym]
          end
        end
      end

      context "with valid arguments on creating new object" do
        let(:merge_object) { Notifier::MergeDataModels::EmployeeProfile.new }
        it "should be valid" do
          ['notice_date', 'first_name', 'last_name', 'employer_name', 'date_of_hire', 'earliest_coverage_begin_date', 'new_hire_oe_start_date', 'new_hire_oe_end_date'].each do |type|
            expect(merge_object[type]).to eq merge_object[type.to_sym]
          end  
        end

        it 'should match address key' do
          expect(merge_object.attributes).to have_key(:mailing_address)
        end
      end

      describe "#stubbed_object" do 
        let(:stubbed_object) { Notifier::MergeDataModels::EmployeeProfile.stubbed_object}

        it 'returns self' do
          klass = Class.new { include Virtus.model}
          ['notice_date', 'first_name', 'last_name', 'employer_name', 'date_of_hire', 'earliest_coverage_begin_date', 'new_hire_oe_start_date', 'new_hire_oe_end_date'].each do |type|
            expect(klass.attribute(stubbed_object[type.to_sym])).to be(klass)
          end
        end

        it 'an object with string attribute' do
          expect(employee_profile.attributes.keys).to eq [:notice_date, :first_name, :last_name, :mailing_address, :employer_name, :broker, :date_of_hire, :earliest_coverage_begin_date, :new_hire_oe_start_date, :new_hire_oe_end_date, :addresses, :enrollment, :plan_year]
        end
      end
    end
  end
end