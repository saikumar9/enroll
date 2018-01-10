FactoryGirl.define do
  factory :notifier_template, class: 'Notifier::Template' do
    raw_body "rspec_raw_body"
    raw_header "rspec-header"
    raw_footer "rspec-footer"
    template_key "rspec-template-key"

    trait :notice_kind do
      notice_kind { FactoryGirl.build(:notice_kind) }
    end
  end
end

