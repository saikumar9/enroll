FactoryGirl.define do
  factory :person do

    first_name 'John'
    sequence(:last_name) {|n| "Smith#{n}" }
    dob "1972-04-04".to_date
    is_incarcerated false
    is_active true
    gender "male"

  end
end
