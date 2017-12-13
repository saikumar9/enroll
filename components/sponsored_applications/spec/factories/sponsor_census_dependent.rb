FactoryBot.define do
  factory :sponsor_census_dependent do
    first_name "Dependent"
    sequence(:last_name) {|n| "Vedder#{n}" }
    dob "1964-10-23".to_date
    gender "male"
    employee_relationship 'spouse'
  end
end
