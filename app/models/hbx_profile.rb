class HbxProfile
  include Config::SiteModelConcern
  include Config::ContactCenterModelConcern
  include SetCurrentUser
  extend Acapi::Notifiers
  include CoreModelConcerns::HbxProfileConcern
  
  embedded_in :organization
  
  embeds_many :hbx_staff_roles
  embeds_many :enrollment_periods # TODO: deprecated - should be removed by 2015-09-03 - Sean Carley
  
  def active_employers
    EmployerProfile.active
  end

  def inactive_employers
    EmployerProfile.inactive
  end

  def active_employees
    CensusEmployee.active
  end

  def active_broker_agencies
    BrokerAgencyProfile.active
  end

  def inactive_broker_agencies
    BrokerAgencyProfile.inactive
  end

  def active_brokers
    BrokerRole.active
  end

  def inactive_brokers
    BrokerRole.inactive
  end


  class << self
    
    def current_hbx
      find_by_state_abbreviation(aca_state_abbreviation)
    end

    def transmit_group_xml(employer_profile_ids)
      hbx_ids = []
      employer_profile_ids.each do |empr_id|
        empr = EmployerProfile.find(empr_id)
        hbx_ids << empr.hbx_id
        empr.update_attribute(:xml_transmitted_timestamp, Time.now.utc)
      end
      notify("acapi.info.events.employer.group_files_requested", { body: hbx_ids } )
    end

    def search_random(search_param)
      if search_param.present?
        organizations = Organization.where(legal_name: /#{search_param}/i)
        broker_agency_profiles = []
        organizations.each do |org|
          broker_agency_profiles << org.broker_agency_profile if org.broker_agency_profile.present?
        end
      else
        broker_agency_profiles = BrokerAgencyProfile.all
      end
      broker_agency_profiles
    end
  end

  ## Application-level caching
  
    ## HBX general settings
    StateName = aca_state_name
    StateAbbreviation = aca_state_abbreviation
    CallCenterName = contact_center_name
    CallCenterPhoneNumber = contact_center_phone_number
    ShortName = site_short_name

    # IndividualEnrollmentDueDayOfMonth = 15
    # Temporary change for Dec 2015 extension
    IndividualEnrollmentDueDayOfMonth = 19
    IndividualEnrollmentTerminationMinimum = 14.days
    
    ShopOpenEnrollmentBeginDueDayOfMonth = Settings.aca.shop_market.open_enrollment.monthly_end_on - Settings.aca.shop_market.open_enrollment.minimum_length.days
    ShopPlanYearPublishedDueDayOfMonth = ShopOpenEnrollmentBeginDueDayOfMonth
    ShopOpenEnrollmentAdvBeginDueDayOfMonth = Settings.aca.shop_market.open_enrollment.minimum_length.adv_days
  ## Carriers
  # hbx_id, hbx_carrier_id, name, abbrev,

  ## Plans & Premiums
  # hbx_id, hbx_plan_id, hbx_carrier_id, hios_id, year, quarter, name, abbrev, market, type, metal_level, pdf

  ## Cross-reference ID Directory
  # Person
  # Employer
  # BrokerAgency
  # Policy

  ## HBX Policies for IVL Market
  # Open Enrollment periods

  ## SHOP Market HBX Policies
  # Employer Contribution Strategies

  # New hires in initial group that start after enrollment, but prior to coverage effective date.  Don't
  # transmit EDI prior to Employer coverage effective date


  # Maximum number of days an Employer may notify HBX of termination
  # may terminate an employee and effective date
  # ShopRetroactiveTerminationMaximum = 60.days
  #
  # # Length of time preceeding next effective date that an employer may renew
  # ShopMaximumRenewalPeriodBeforeStartOn = 3.months
  #
  # # Length of time preceeding effective date that an employee may submit a plan enrollment
  # ShopMaximumEnrollmentPeriodBeforeEligibilityInDays = 30
  #
  # # Length of time following effective date that an employee may submit a plan enrollment
  # ShopMaximumEnrollmentPeriodAfterEligibilityInDays = 30
  #
  # # Minimum number of days an employee may submit a plan, following addition or correction to Employer roster
  # ShopMinimumEnrollmentPeriodAfterRosterEntryInDays = 30
  #
  # # TODO - turn into struct that includes count, plus effective date range
  # ShopApplicationAppealPeriodMaximum = 30.days
  #
  # # After submitting an ineligible plan year application, time period an Employer must wait
  # #   before submitting a new application
  # ShopApplicationIneligiblePeriodMaximum = 90.days
  #
  # # TODO - turn into struct that includes count, plus effective date range
  # ShopSmallMarketFteCountMaximum = 50
  #
  # ## SHOP enrollment-related periods in days
  # # Minimum number of days for SHOP open enrollment period
  # ShopOpenEnrollmentPeriodMinimum = 5
  # ShopOpenEnrollmentEndDueDayOfMonth = 10
  #
  # # Maximum number of months for SHOP open enrollment period
  # ShopOpenEnrollmentPeriodMaximum = 2
  #
  # # Minumum length of time for SHOP Plan Year
  # ShopPlanYearPeriodMinimum = 1.year - 1.day
  #
  # # Maximum length of time for SHOP Plan Year
  # ShopPlanYearPeriodMaximum = 1.year - 1.day
  #
  # # Maximum number of months prior to coverage effective date to submit a Plan Year application
  # ShopPlanYearPublishBeforeEffectiveDateMaximum = 3.months
  #
  # ShopEmployerContributionPercentMinimum = 50.0
  # ShopEnrollmentParticipationRatioMinimum = 2 / 3.0
  # ShopEnrollmentNonOwnerParticipationMinimum = 1
  #
  # ShopBinderPaymentDueDayOfMonth = 15
  # ShopRenewalOpenEnrollmentEndDueDayOfMonth = 13

  # ShopOpenEnrollmentStartMax
  # EffectiveDate

  # CoverageEffectiveDate - no greater than 3 calendar months max
  # ApplicationPublished latest date - 5th end_of_day  of preceding month

  # OpenEnrollment earliest start - 2 calendar months preceding CoverageEffectiveDate
  # OpenEnrollment min length - 5 days
  # OpenEnrollment latest start date - 5th of month
  # OpenEnrollmentLatestEnd -- 10th day of month prior to effective date
  # BinderPaymentDueDate -- 15th or earliest banking day prior


end
