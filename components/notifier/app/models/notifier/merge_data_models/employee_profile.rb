module Notifier
  class MergeDataModels::EmployeeProfile
    include Virtus.model
    include ActiveModel::Model
    include Notifier::MergeDataModels::TokenBuilder

    attribute :notice_date, String
    attribute :first_name, String
    attribute :last_name, String
    attribute :enrollment_plan_name, String
    attribute :mailing_address, MergeDataModels::Address
    attribute :employer_name, String
    # attribute :coverage_begin_date, Date
    attribute :broker, MergeDataModels::Broker
    attribute :date_of_hire, String
    attribute :termination_of_employment, String
    attribute :coverage_terminated_on, String
    attribute :earliest_coverage_begin_date, String
    attribute :new_hire_oe_start_date, String
    attribute :new_hire_oe_end_date, String
    attribute :addresses, Array[MergeDataModels::Address]
    attribute :enrollment, MergeDataModels::Enrollment
    attribute :plan_year, MergeDataModels::PlanYear
    attribute :census_employee, MergeDataModels::CensusEmployee

    def self.stubbed_object
      notice = Notifier::MergeDataModels::EmployeeProfile.new({
        notice_date: TimeKeeper.date_of_record.strftime('%m/%d/%Y'),
        first_name: 'John',
        last_name: 'Whitmore',
        employer_name: 'MA Health Connector',
        # coverage_begin_date: TimeKeeper.date_of_record.strftime('%m/%d/%Y'),
        date_of_hire: TimeKeeper.date_of_record.strftime('%m/%d/%Y') ,
        earliest_coverage_begin_date: TimeKeeper.date_of_record.next_month.beginning_of_month.strftime('%m/%d/%Y'),
        new_hire_oe_end_date: (TimeKeeper.date_of_record + 30.days).strftime('%m/%d/%Y'),
        new_hire_oe_start_date: TimeKeeper.date_of_record.strftime('%,/%d/%Y')
      })
      notice.mailing_address = Notifier::MergeDataModels::Address.stubbed_object
      notice.broker = Notifier::MergeDataModels::Broker.stubbed_object
      notice.addresses = [ notice.mailing_address ]
      notice.enrollment = Notifier::MergeDataModels::Enrollment.stubbed_object
      notice.plan_year = Notifier::MergeDataModels::PlanYear.stubbed_object
      notice.census_employee = Notifier::MergeDataModels::CensusEmployee.stubbed_object
      notice
    end

    def collections
      []
    end

    def conditions
      %w{broker_present? census_employee_health_and_dental_enrollment? census_employee_health_enrollment? census_employee_dental_enrollment?}
    end

    def census_employee_health_enrollment?
      self.census_employee.latest_terminated_health_enrollment_plan_name.present?
    end

    def census_employee_dental_enrollment?
      self.census_employee.latest_terminated_dental_enrollment_plan_name.present?
    end

    def census_employee_health_and_dental_enrollment?
      census_employee_health_enrollment? && census_employee_dental_enrollment?
    end

    def broker_present?
      self.broker.present?
    end
  end
end