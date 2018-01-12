require 'rails_helper'

module Notifier
	describe MergeDataModels::PlanYear, "with proper validations" do
    let(:plan_year_params) {
      {
        :current_py_oe_start_date => "10/10/2017",
        :current_py_oe_end_date => "10/10/2017",
        :current_py_start_date => "10/12/2017",
        :current_py_end_date => "10/12/2017",
        :renewal_py_oe_start_date => "10/10/2017",
        :renewal_py_oe_end_date => "10/12/2017",
        :renewal_py_start_date => "10/10/2017",
        :renewal_py_end_date => "10/12/2017",
        :renewal_py_submit_soft_due_date => "10/08/2017",
        :renewal_py_submit_due_date => "10/09/2017",
        :binder_payment_due_date => "10/10/2017",
        :current_py_start_on => Date.new(2017,10,10),
        :current_py_end_on => Date.new(2017,12,10),
        :renewal_py_start_on => Date.new(2017,10,10),
        :renewal_py_end_on => Date.new(2017,12,10),
        :carrier_name =>  "Ruby" ,
        :renewal_carrier_name => "Ruby2",
        :warnings => ["warning_1", "wanrning_2"],
        :errors => ["error_1", "error_2"],
        :enrollment_errors => {:one => "enr_error_1", :two => "enr_error_2"}
      }
    }

	  let(:subject1000) { Notifier::MergeDataModels::PlanYear.new(plan_year_params) }

	  context "with valid arguments" do
      it "should have a specific number of attributes" do
        expect(subject1000.attributes.keys.count).to eq 20
      end

	    it "should be valid" do
        subject1000.attributes.keys.each do |t_key|
          expect(subject1000[t_key]).to eq plan_year_params[t_key.to_sym]
        end
	    end
	  end

    context "with invalid arguments" do
      it "should not be valid" do
        [:current_py_oe_start_date, :current_py_oe_end_date, :current_py_start_date, :current_py_end_date].each do |t_key|
          plan_year_params[t_key.to_sym] = nil
          test10 = Notifier::MergeDataModels::PlanYear.new(plan_year_params)
          expect(test10[t_key]).to eq nil
        end
      end
    end

    context "for stubbed_object" do
      let(:reference_date) { TimeKeeper.date_of_record.next_month.beginning_of_month }
      let(:current_py_start) { reference_date.prev_year }
      let(:renewal_py_start) { reference_date }

      it "should return valid values" do
        test100 = Notifier::MergeDataModels::PlanYear.stubbed_object
        expect(test100.attributes.keys.count).to eq 20
        expect(test100[:binder_payment_due_date]). to eq (current_py_start.prev_month + 22.days).strftime('%m/%d/%Y')
        expect(test100[:carrier_name]). to eq 'Kaiser'
        expect(test100[:renewal_carrier_name]). to eq 'Kaiser'
        expect(test100[:current_py_oe_start_date]). to eq (current_py_start.prev_month).strftime('%m/%d/%Y')
        expect(test100[:enrollment_errors]). to eq ({non_business_owner_enrollment_count: "at least 3 non-owner employee must enroll"})
      end
    end
  end
end
