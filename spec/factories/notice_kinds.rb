FactoryGirl.define do
  factory :notice_kind, :class => Notifier::NoticeKind do |attr|
    attr.title "rspec-titile"
    attr.notice_number "rspec-MPI"
    attr.recipient "Notifier::MergeDataModels::EmployerProfile"
    attr.event_name nil
  end
end

