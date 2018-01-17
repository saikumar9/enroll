require 'rails_helper'

module Notifier
  RSpec.describe NotificationSubscriber, type: :modal, dbclean: :after_each do

    describe '#subscription_details' do
      it 'should return subscription_details' do
        expect(Notifier::NotificationSubscriber.subscription_details).to eq  [/acapi\.info\.events\..*/]
      end
    end

    describe '.call' do
      let!(:notice_kind) { FactoryGirl.create(:notifier_notice_kind, notice_number: "rspec_notice_number", event_name: "rspec")}
      let!(:payload) { {"rspec" => "event_object_kind" } }
      let!(:event_name) { 'acapi.info.events.rspec_event_name.rspec' }
      subject { Notifier::NotificationSubscriber.new }

      it 'should invoke execute notice' do
        # Needs some improvements
        allow_any_instance_of(Notifier::NoticeKind).to receive(:execute_notice).with(event_name, payload).and_return nil
        expect(subject.call(event_name, nil, nil, nil, payload)).to be_kind_of(Mongoid::Contextual::Mongo)
      end
    end


  end
end
