FactoryGirl.define do
  factory :notifier_notice_kind, class: 'Notifier::NoticeKind' do
    title 'rspec_title'
    sequence(:notice_number) { |n| "notice_number_#{n}"}
    recipient 'Notifier::MergeDataModels::EmployerProfile'
  end
end
