FactoryGirl.define do
  factory :notifier_notice_event, class: 'Notifier::NoticeEvent' do
    event_name "rspec-event_name"
    event_model_name "rspec-model-name"
    event_model_id  { BSON::ObjectId.from_time(DateTime.now) }
    event_model_payload { {:rspec => 'factory'} }
    received_at { DateTime.now }
  end
end
