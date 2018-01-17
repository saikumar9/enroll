FactoryGirl.define do
  factory :notifier_merge_data_models_employee_profile, class: 'Notifier::MergeDataModels::EmployeeProfile' do
    notice_date TimeKeeper.date_of_record
    first_name 'John'
    last_name 'Whitmore'
    employer_name 'MA Health Connector'
    date_of_hire TimeKeeper.date_of_record 
    earliest_coverage_begin_date TimeKeeper.date_of_record.next_month.beginning_of_month
    new_hire_oe_end_date (TimeKeeper.date_of_record + 30.days)
    new_hire_oe_start_date TimeKeeper.date_of_record
  end
end