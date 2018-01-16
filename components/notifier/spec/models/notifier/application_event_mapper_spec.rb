require 'rails_helper'

module Notifier
  RSpec.describe ApplicationEventMapper, type: :model do

    describe '#extract_event_parts' do
      let!(:event_name) { 'acapi.info.events.employee.rspec' }

      it 'should extract event name' do
        expect(Notifier::ApplicationEventMapper.extract_event_parts(event_name)).to eq  ["employee", "rspec"]
      end
    end

    describe '#lookup_resource_mapping' do
     let!(:event_name) { 'acapi.info.events.employee.rspec' }
     let!(:event_name_with_no_key) { 'acapi.info.events.EmployeeRole.rspec' }

      it 'should return value from model constant' do
       value = Notifier::ApplicationEventMapper.lookup_resource_mapping(event_name)
        expect(value).to be_kind_of(Struct)
        expect(value.mapped_class).to eq EmployeeRole
        expect(value.identifier_key).to eq "employee_role_id"
        expect(value.search_method).to eq :find
      end

      it 'should handles exception and returns nil' do
        expect(Notifier::ApplicationEventMapper.lookup_resource_mapping("rspec-event")).to be_nil
      end
    end

    describe '#map_resource' do
      let!(:resource_name) { 'EmployerProfile' }
      let!(:resource_name_no_key) { 'Rspec' }

      it 'should return resource from hash key' do
        val = Notifier::ApplicationEventMapper.map_resource(resource_name)
        expect(val).to be_kind_of Struct
        expect(val.resource_name).to eq :employer
        expect(val.identifier_method).to eq :hbx_id
        expect(val.identifier_key).to eq :employer_id
        expect(val.search_method).to eq :by_hbx_id
      end

      it 'should return resource not from hash' do
        val = Notifier::ApplicationEventMapper.map_resource(resource_name_no_key)
        expect(val.resource_name).to eq :rspec
        expect(val.identifier_method).to eq :id
        expect(val.identifier_key).to eq :rspec_id
        expect(val.search_method).to eq :find
      end

    end

    describe '#map_event_name' do
       let!(:resource_mapping) {  Notifier::ApplicationEventMapper.map_resource('EmployerProfile')}
       let!(:transition_event_name) { 'renewal_employer_open_enrollment_completed' }
       let!(:mock_resource_mapping) { double("ResourceMapping", resource_name: :employer)}
       let!(:mock_transition_event) { "binder_paid"}

      it 'should not map the event_name' do
        expect(Notifier::ApplicationEventMapper.map_event_name(resource_mapping, transition_event_name)).to eq 'acapi.info.events.employer.renewal_employer_open_enrollment_completed'
      end

      it 'should append from EVENT_MAP constant' do
        expect(Notifier::ApplicationEventMapper.map_event_name(mock_resource_mapping, mock_transition_event)).to eq 'acapi.info.events.employer.benefit_coverage_initial_binder_paid'
      end

    end
  end
end
