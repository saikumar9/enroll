FactoryGirl.define do
  factory :notifier_merge_data_models_address, class: 'Notifier::MergeDataModels::Address' do
    sequence(:street_1, 1111) { |n| "#{n} Awesome Street" }
    sequence(:street_2, 111) { |n| "##{n}" }
    city 'Turners Falls'
    state 'MA'
    sequence(:zip, 11111)
  end
end
