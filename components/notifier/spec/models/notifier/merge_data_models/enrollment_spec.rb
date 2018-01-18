require 'rails_helper'

module Notifier
  RSpec.describe MergeDataModels::Enrollment, type: :model do

    describe MergeDataModels::Enrollment, "with proper validations" do
      context "with valid arguments on factory" do
      let(:enrollment)  {  FactoryGirl.build :notifier_merge_data_models_enrollment }
        let(:enrollment_params) {
          {
            coverage_start_on: enrollment.coverage_start_on,
            plan_name: enrollment.plan_name,
            employee_responsible_amount: enrollment.employee_responsible_amount,
            employer_responsible_amount: enrollment.employer_responsible_amount,
          }
        }

        it "should be valid" do
          ['coverage_start_on', 'plan_name', 'employer_responsible_amount', 'employee_responsible_amount'].each do |type|
            expect(enrollment[type]).to eq enrollment_params[type.to_sym]
          end
        end
      end

      context "with valid arguments on creating new object" do
        let(:merge_object) { Notifier::MergeDataModels::Enrollment.new }
        it "should be valid" do
          ['coverage_start_on', 'plan_name', 'employer_responsible_amount', 'employee_responsible_amount'].each do |type|
            expect(merge_object[type]).to eq merge_object[type.to_sym]
          end
        end
      end
    end

    describe "#stubbed_object" do 
      let(:stubbed_object) { Notifier::MergeDataModels::Enrollment.stubbed_object}

      it 'returns self' do
        klass = Class.new { include Virtus.model }
        ['coverage_start_on', 'plan_name', 'employer_responsible_amount', 'employee_responsible_amount'].each do |type|
          expect(klass.attribute(stubbed_object[type.to_sym])).to be(klass)
        end
      end

      it 'an object with string attribute' do
        expect(stubbed_object.attributes.keys).to eq [:coverage_start_on, :plan_name, :employee_responsible_amount, :employer_responsible_amount]
      end
    end
  end
end