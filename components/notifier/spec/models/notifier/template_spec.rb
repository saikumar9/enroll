require 'rails_helper'

module Notifier
  RSpec.describe Template, type: :model, dbclean: :after_each do

    describe 'validators for model' do
      it { is_expected.to be_mongoid_document }
      it { is_expected.to have_fields(:markup_kind, :raw_body, :raw_header, :raw_footer, :template_key, :data_elements) }
      it { is_expected.to have_field(:raw_body).of_type(String) }
      it { is_expected.to have_field(:markup_kind).of_type(String).with_default_value_of('markdown') }
      it { is_expected.to be_embedded_in(:notice_kind) }
      it { is_expected.to validate_presence_of(:raw_body).on(:create) }
    end

    describe '#attributes' do

      context 'when factoryGirl.build is used ' do
        # this factory does not have parent document but it is valid
        # we can not use FactoryGirl.create, to use we need to use :notice_kind trait
        subject { FactoryGirl.build(:notifier_template) }

        it 'has matching attributes' do
          expect(subject.attributes).to include 'raw_body'
          expect(subject.attributes).to include 'raw_header'
        end

        it 'has a valid factory or not' do
          expect(subject.valid?).to be_truthy
        end
      end

      context 'when factoryGirl.create is used ' do
        subject { FactoryGirl.create(:notifier_template, :notice_kind) }

        it 'has matching attributes' do
          expect(subject.notice_kind).not_to be nil
        end

        it 'has a valid factory or not' do
          expect(subject.valid?).to be_truthy
        end
      end
    end


    describe '#object initialization validation' do
      let(:notice_kind) { FactoryGirl.build(:notice_kind) }
      let(:template) { Notifier::Template.new }
      context '#new' do
        it 'should not be a valid record' do
          expect(Notifier::Template.new.valid?).to be_falsy
        end

        it 'should be valid record' do
          template.update_attributes!(raw_body: 'rspec-body', notice_kind: notice_kind)
          expect(template.valid?).to be_truthy
        end

        it 'have a valid default values' do
          expect(template.markup_kind).to eq 'markdown'
          expect(template.data_elements).to eq []
        end
      end
    end

  end
end
