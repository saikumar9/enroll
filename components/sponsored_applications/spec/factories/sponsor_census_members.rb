FactoryBot.define do
  factory :sponsor_census_member do
    first_name "Eddie"
    sequence(:last_name) {|n| "Vedder#{n}" }
    dob "1964-10-23".to_date
    gender "male"
    employee_relationship 'self'
    association :sponsor, strategy: :build

    after(:create) do |sponsor_census_member, evaluator|
      sponsor_census_member.created_at = TimeKeeper.date_of_record
      if evaluator.create_with_spouse
        sponsor_census_member.sponsor_census_dependents.create(employee_relationship: 'spouse')
      end
    end
  end
end
