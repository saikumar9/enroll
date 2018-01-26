FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "example#{n}@example.com"}
    sequence(:oim_id) {|n| "example#{n}"}
    gen_pass = User.generate_valid_password
    password gen_pass
    password_confirmation gen_pass
    sequence(:authentication_token) {|n| "j#{n}-#{n}DwiJY4XwSnmywdMW"}
    approved true
    roles ['web_service']
  end

  trait :hbx_staff do
    roles ["hbx_staff"]

    after :create do |user, evaluator|
      if user.person.present?
        user.person.hbx_staff_role = FactoryGirl.build :hbx_staff_role
        user.save
      end
    end
  end

  trait :with_person do
    after :create do |user|
      FactoryGirl.create :person, :user => user
    end
  end
end
