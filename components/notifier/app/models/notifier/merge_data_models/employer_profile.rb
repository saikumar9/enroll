module Notifier
  class MergeDataModels::EmployerProfile
    include Virtus.model
    include ActiveModel::Model
    include Notifier::MergeDataModels::TokenBuilder
    
    attribute :primary_fullname, String, default: 'John Whitmore'
    attribute :primary_identifier, String
    attribute :mpi_indicator, String
    attribute :notice_date, Date, default: '08/07/2017'
    attribute :application_date, Date
    attribute :employer_name, String, default: 'MA Health Connector'
    attribute :primary_address, MergeDataModels::Address
    attribute :broker, MergeDataModels::Broker
    attribute :to, String
    attribute :plan, MergeDataModels::Plan
    attribute :plan_year, MergeDataModels::PlanYear
    attribute :addresses, Array[MergeDataModels::Address]

    def self.stubbed_object
      notice = Notifier::MergeDataModels::EmployerProfile.new
      notice.primary_address = Notifier::MergeDataModels::Address.new
      notice.plan_year = Notifier::MergeDataModels::PlanYear.new
      notice.plan = Notifier::MergeDataModels::Plan.new
      notice.broker = Notifier::MergeDataModels::Broker.new
      notice.addresses = [ notice.primary_address ]
      notice
    end

    def collections
      %w{addresses}
    end

    def conditions
      %w{broker_present?}
    end

    def broker_present?
      self.broker.present?
    end
  end
end
