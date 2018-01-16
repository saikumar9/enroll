require 'rails_helper'

module Notifier
  RSpec.describe Job, type: :model do

    describe 'validators for model' do
      it { is_expected.to be_mongoid_document }
      it { is_expected.to have_fields(:description, :run_at, :transmit_at, :expires_at, :started_at, :completed_at) }
      it { is_expected.to have_field(:destroy_on_complete).of_type(Mongoid::Boolean).with_default_value_of(true) }
      it { is_expected.to have_field(:state).of_type(Symbol).with_default_value_of(:queued) }
      it { is_expected.to have_field(:priority).of_type(Integer).with_default_value_of(50) }
      it { is_expected.to have_field(:expires_at).of_type(Time) }
    end

    describe '.new' do
      subject { Notifier::Job.new }
      it { expect(subject.valid?).to be_truthy }
    end

    describe 'factories' do
      let!(:notifier_job) { FactoryGirl.build(:notifier_job) }
      let!(:notifier_create_job) { FactoryGirl.create(:notifier_job) }

      it 'should be able to build ' do
        expect(notifier_job.valid?).to be_truthy
        expect(notifier_create_job.valid?).to be_truthy
      end

    end

  end
end
