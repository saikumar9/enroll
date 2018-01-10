require 'rails_helper'

module Notifier
  RSpec.describe NoticeEvent, type: :model do

    describe 'validators for model' do
      it { is_expected.to be_mongoid_document }
      it { is_expected.to have_fields(:event_name, :event_model_name, :event_model_id, :event_model_payload, :received_at) }
      it { is_expected.to have_field(:event_model_id).of_type(BSON::ObjectId) }
      it { is_expected.to have_field(:event_model_payload).of_type(Hash) }
      it { is_expected.to have_field(:received_at).of_type(DateTime) }
    end

    describe '#attributes' do
      context 'when factoryGirl.build is used ' do
        subject { FactoryGirl.build(:notifier_notice_event) }

        it 'has matching attributes' do
          expect(subject.attributes).to include 'event_name'
          expect(subject.attributes).to include 'event_model_name'
        end

        it 'has a valid factory or not' do
          expect(subject.valid?).to be_truthy
        end

      end
    end

    describe '#object initialization validation' do

      let(:notice_event) { Notifier::NoticeEvent.new }
      context '#new' do

        it 'should be a valid record' do
          expect(Notifier::NoticeEvent.new.valid?).to be_truthy
        end

      end
    end

  end
end
