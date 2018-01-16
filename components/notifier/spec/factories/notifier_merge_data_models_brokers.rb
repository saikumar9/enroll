FactoryGirl.define do
  factory :notifier_merge_data_models_broker, class: 'Notifier::MergeDataModels::Broker' do
    primary_fullname 'Count Olaf'
    organization 'Best Brokers LLC'
    phone '703-303-1007'
    email 'count.olaf@bestbrokers.llc'
    web_address 'http://bestbrokers.llc'
  end
end
