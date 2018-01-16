FactoryGirl.define do
  factory :notifier_merge_data_models_enrollment, class: 'Notifier::MergeDataModels::Enrollment' do
    coverage_start_on TimeKeeper.date_of_record.end_of_month + 1.day
    plan_name 'AETNA GOLD'
    employee_responsible_amount '$220.0'
    employer_responsible_amount '$85.0'
  end
end
