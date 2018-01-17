FactoryGirl.define do
  factory :notifier_merge_data_models_broker_profile, class: 'Notifier::MergeDataModels::BrokerProfile' do
		notice_date TimeKeeper.date_of_record
    first_name 'John'
    last_name 'Whitmore'
    broker_agency_name 'Best Brokers LLC'
    assignment_date TimeKeeper.date_of_record
    employer_name 'North America Football Federation'
    employer_poc_firstname 'David'
    employer_poc_lastname 'Samules'
  end
end
