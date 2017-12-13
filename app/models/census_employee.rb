class CensusEmployee < CensusMember
  include ShopModelConcerns::CensusEmployeeConcern
  include Sortable
  include Searchable
  # include Validations::EmployeeInfo
  include Autocomplete
  include Acapi::Notifiers
  include Config::AcaModelConcern
  include ::Eligibility::CensusEmployee
  include ::Eligibility::EmployeeBenefitPackages

  require 'roo'

  embeds_many :benefit_group_assignments,
    cascade_callbacks: true,
    validate: true

  accepts_nested_attributes_for :benefit_group_assignments

  validate :check_employment_terminated_on
  validate :active_census_employee_is_unique
  validate :allow_id_info_changes_only_in_eligible_state
  validate :check_census_dependents_relationship
  validate :no_duplicate_census_dependent_ssns
  validate :check_cobra_begin_date
  validate :check_hired_on_before_dob

  after_update :update_hbx_enrollment_effective_on_by_hired_on

  before_save :assign_default_benefit_package
  before_save :allow_nil_ssn_updates_dependents

  index({"benefit_group_assignments._id" => 1})
  index({"benefit_group_assignments.benefit_group_id" => 1})
  index({"benefit_group_assignments.aasm_state" => 1})

  # scope :emplyee_profiles_active_cobra,        ->{ where(aasm_state: "eligible") }
  scope :employee_profiles_terminated,         ->{ where(aasm_state: "employment_terminated")}

  #TODO - need to add fix for multiple plan years
  # scope :enrolled,    ->{ where("benefit_group_assignments.aasm_state" => ["coverage_selected", "coverage_waived"]) }
  # scope :covered,     ->{ where( "benefit_group_assignments.aasm_state" => "coverage_selected" ) }
  # scope :waived,      ->{ where( "benefit_group_assignments.aasm_state" => "coverage_waived" ) }

  scope :covered,    ->{ where(:"benefit_group_assignments" => {
    :$elemMatch => { :aasm_state => "coverage_selected", :is_active => true }
    })}

  scope :waived,    ->{ where(:"benefit_group_assignments" => {
    :$elemMatch => { :aasm_state => "coverage_waived", :is_active => true }
    })}

  scope :enrolled, -> { any_of([covered.selector, waived.selector]) }

  scope :by_benefit_group_assignment_ids, ->(benefit_group_assignment_ids) { any_in("benefit_group_assignments._id" => benefit_group_assignment_ids) }
  scope :by_benefit_group_ids,            ->(benefit_group_ids) { any_in("benefit_group_assignments.benefit_group_id" => benefit_group_ids) }

  scope :matchable, ->(ssn, dob) {
    matched = unscoped.and(encrypted_ssn: CensusMember.encrypt_ssn(ssn), dob: dob, aasm_state: {"$in": ELIGIBLE_STATES })
    benefit_group_assignment_ids = matched.flat_map() do |ee|
      ee.published_benefit_group_assignment ? ee.published_benefit_group_assignment.id : []
    end
    matched.by_benefit_group_assignment_ids(benefit_group_assignment_ids)
  }

  scope :unclaimed_matchable, ->(ssn, dob) {
   linked_matched = unscoped.and(encrypted_ssn: CensusMember.encrypt_ssn(ssn), dob: dob, aasm_state: {"$in": LINKED_STATES})
   unclaimed_person = Person.where(encrypted_ssn: CensusMember.encrypt_ssn(ssn), dob: dob).detect{|person| person.employee_roles.length>0 && !person.user }
   unclaimed_person ? linked_matched : unscoped.and(id: {:$exists => false})
  }

  def allow_nil_ssn_updates_dependents
    census_dependents.each do |cd|
      if cd.ssn.blank?
        cd.unset(:encrypted_ssn)
      end
    end
  end

  def update_hbx_enrollment_effective_on_by_hired_on
    if employee_role.present? && hired_on != employee_role.hired_on
      employee_role.set(hired_on: hired_on)
      enrollments = employee_role.person.primary_family.active_household.hbx_enrollments.shop_market.enrolled_and_renewing.open_enrollments rescue []
      enrollments.each do |enrollment|
        if hired_on > enrollment.effective_on
          effective_on = enrollment.benefit_group.effective_on_for(hired_on)
          enrollment.update_current(effective_on: effective_on)
        end
      end
    end
  end

  def suggested_cobra_effective_date
    return nil if self.employment_terminated_on.nil?
    self.employment_terminated_on.next_month.beginning_of_month
  end

  # This performs employee summary count for waived and enrolled in the latest plan year
  def perform_employer_plan_year_count
    if plan_year = self.employer_profile.latest_plan_year
      plan_year.enrolled_summary = plan_year.total_enrolled_count
      plan_year.waived_summary = plan_year.waived_count
      plan_year.save!
    end
  end

  def employee_role=(new_employee_role)
    raise ArgumentError.new("expected EmployeeRole") unless new_employee_role.is_a? EmployeeRole
    return false unless self.may_link_employee_role?

    # Guard against linking employee roles with different employer/identifying information
    if (self.employer_profile_id == new_employee_role.employer_profile._id)
      self.employee_role_id = new_employee_role._id
      self.link_employee_role
      @employee_role = new_employee_role
      self
    else
      message =  "Identifying information mismatch error linking employee role: "\
                 "#{new_employee_role.inspect} "\
                 "with census employee: #{self.inspect}"
      Rails.logger.error { message }
      #raise CensusEmployeeError, message
    end
  end

  def employee_role
    return @employee_role if defined? @employee_role
    @employee_role = EmployeeRole.find(self.employee_role_id) unless self.employee_role_id.blank?
  end

  def qle_30_day_eligible?
    is_inactive? && (TimeKeeper.date_of_record - employment_terminated_on).to_i < 30
  end

  # Initialize a new, refreshed instance for rehires via deep copy
  def replicate_for_rehire
    return nil unless self.employment_terminated?
    new_employee = self.dup
    new_employee.hired_on = nil
    new_employee.employment_terminated_on = nil
    new_employee.employee_role_id = nil
    new_employee.benefit_group_assignments = []
    new_employee.aasm_state = :eligible
    self.rehire_employee_role

    # new_employee.census_dependents = self.census_dependents unless self.census_dependents.blank?
    new_employee
  end

  def is_business_owner?
    is_business_owner
  end

  def is_covered_or_waived?
    ["coverage_selected", "coverage_waived"].include?(active_benefit_group_assignment.aasm_state)
  end

  def email_address
    return nil unless email.present?
    email.address
  end

  def terminate_employment(employment_terminated_on)
    begin
      terminate_employment!(employment_terminated_on)
    rescue => e
      Rails.logger.error { e }
      false
    else
      self
    end
  end

  def terminate_employee_enrollments
    [self.active_benefit_group_assignment, self.renewal_benefit_group_assignment].compact.each do |assignment|
      enrollments = HbxEnrollment.find_enrollments_by_benefit_group_assignment(assignment)
      enrollments.each do |e|
        if e.effective_on > self.coverage_terminated_on
          e.cancel_coverage!(self.employment_terminated_on) if e.may_cancel_coverage?
        else
          if self.coverage_terminated_on < TimeKeeper.date_of_record
            e.terminate_coverage!(self.coverage_terminated_on) if e.may_terminate_coverage?
          else
            e.schedule_coverage_termination!(self.coverage_terminated_on) if e.may_schedule_coverage_termination?
          end
        end
      end
    end
  end

  def terminate_employment!(employment_terminated_on)
    if may_schedule_employee_termination?
      self.employment_terminated_on = employment_terminated_on
      self.coverage_terminated_on = earliest_coverage_termination_on(employment_terminated_on)
    end

    if employment_terminated_on < TimeKeeper.date_of_record
      if may_terminate_employee_role?
        terminate_employee_role!
        perform_employer_plan_year_count
      else
        message = "Error terminating employment: unable to terminate employee role for: #{self.full_name}"
        Rails.logger.error { message }
        raise CensusEmployeeError, message
      end
    else # Schedule Future Terminations as employment_terminated_on is in the future
      schedule_employee_termination! if may_schedule_employee_termination?
    end

    terminate_employee_enrollments
    self
  end

  def earliest_coverage_termination_on(employment_termination_date, submitted_date = TimeKeeper.date_of_record)

    employment_based_date = employment_termination_date.end_of_month
    submitted_based_date  = TimeKeeper.date_of_record.
                              advance(Settings.
                                          aca.
                                          shop_market.
                                          retroactive_coverage_termination_maximum
                                          .to_hash
                                        ).end_of_month

    # if current_user.has_hbx_staff_role?
    # end

    [employment_based_date, submitted_based_date].max
  end

  def is_active?
    EMPLOYMENT_ACTIVE_STATES.include?(aasm_state)
  end

  def is_inactive?
    EMPLOYMENT_TERMINATED_STATES.include?(aasm_state)
  end

  def active_or_pending_termination?
    return true if self.employment_terminated_on.present?
    return true if PENDING_STATES.include?(self.aasm_state)
    return false if self.rehired?
    !(self.is_eligible? || self.employee_role_linked?)
  end

  def build_from_params(census_employee_params, benefit_group_id)
    self.attributes = census_employee_params

    if benefit_group_id.present?
      benefit_group = BenefitGroup.find(BSON::ObjectId.from_string(benefit_group_id))
      new_benefit_group_assignment = BenefitGroupAssignment.new_from_group_and_census_employee(benefit_group, self)
      self.benefit_group_assignments = new_benefit_group_assignment.to_a
    end
  end

  def send_invite!
    if has_benefit_group_assignment?
      plan_year = active_benefit_group_assignment.benefit_group.plan_year
      if plan_year.employees_are_matchable?
        Invitation.invite_employee_for_open_enrollment!(self)
        return true
      end
    end
    false
  end

  def construct_employee_role_for_match_person
    employee_relationship = Forms::EmployeeCandidate.new({first_name: first_name,
                                                          last_name: last_name,
                                                          ssn: ssn,
                                                          dob: dob.strftime("%Y-%m-%d")})
    person = employee_relationship.match_person if employee_relationship.present?
    return false if person.blank? || (person.present? &&
                                      person.has_active_employee_role_for_census_employee?(self))
    Factories::EnrollmentFactory.build_employee_role(person, nil, employer_profile, self, hired_on)
    return true
  end

  def newhire_enrollment_eligible?
    active_benefit_group_assignment.present? && active_benefit_group_assignment.initialized?
  end

  def has_active_health_coverage?(plan_year) # Related code is commented out
    benefit_group_ids = plan_year.benefit_groups.map(&:id)

    bg_assignment = active_benefit_group_assignment if benefit_group_ids.include?(active_benefit_group_assignment.try(:benefit_group_id))
    bg_assignment = renewal_benefit_group_assignment if benefit_group_ids.include?(renewal_benefit_group_assignment.try(:benefit_group_id))

    bg_assignment.present? && HbxEnrollment.enrolled_shop_health_benefit_group_ids([bg_assignment]).present?
  end

  def current_state
    if existing_cobra
      if COBRA_STATES.include? aasm_state
        aasm_state.humanize
      else
        'Cobra'
      end
    else
      aasm_state.humanize
    end
  end

  def update_for_cobra(cobra_date,current_user=nil)
    self.cobra_begin_date = cobra_date
    self.elect_cobra(current_user)
    self.save
  rescue => e
    false
  end

  def need_to_build_renewal_hbx_enrollment_for_cobra?
    renewal_benefit_group_assignment.present? && active_benefit_group_assignment != renewal_benefit_group_assignment
  end

  def build_hbx_enrollment_for_cobra
    family = employee_role.person.primary_family

    cobra_assignments = [active_benefit_group_assignment, renewal_benefit_group_assignment].compact
    hbxs = cobra_assignments.map(&:latest_hbx_enrollments_for_cobra).flatten.uniq rescue []

    hbxs.compact.each do |hbx|
      enrollment_cobra_factory = Factories::FamilyEnrollmentCloneFactory.new
      enrollment_cobra_factory.family = family
      enrollment_cobra_factory.census_employee = self
      enrollment_cobra_factory.enrollment = hbx
      enrollment_cobra_factory.clone_for_cobra
    end
  rescue => e
    logger.error(e)
  end

  class << self

    def enrolled_count(benefit_group)

        return 0 unless benefit_group

        cnt = CensusEmployee.collection.aggregate([
        {"$match" => {"benefit_group_assignments.benefit_group_id" => benefit_group.id  }},
        {"$unwind" => "$benefit_group_assignments"},
        {"$match" => {"aasm_state" => { "$in" =>  EMPLOYMENT_ACTIVE_STATES  } }},
        {"$match" => {"benefit_group_assignments.aasm_state" => { "$in" => ["coverage_selected"]} }},
        #{"$match" => {"benefit_group_assignments.is_active" => true}},
        {"$match" => {"benefit_group_assignments.benefit_group_id" => benefit_group.id  }},
        {"$group" => {
            "_id" =>  { "bgid" => "$benefit_group_assignments.benefit_group_id",
                        #"state" => "$aasm_state",
                        #{}"active" => "$benefit_group_assignments.is_active",
                        #{}"bgstate" => "$benefit_group_assignments.aasm_state"
                      },
                      "count" => { "$sum" => 1 }
                    }
              },
        #{"$match" => {"count" => {"$gte" => 1}}}
      ],
      :allow_disk_use => true)


      if cnt.count >= 1
        return cnt.first['count']
      else
        return 0
      end
    end

    def advance_day(new_date)
      CensusEmployee.terminate_scheduled_census_employees
      CensusEmployee.rebase_newly_designated_employees
      CensusEmployee.terminate_future_scheduled_census_employees(new_date)
      CensusEmployee.initial_employee_open_enrollment_notice(new_date)
      CensusEmployee.census_employee_open_enrollment_reminder_notice(new_date)
    end

    def initial_employee_open_enrollment_notice(date)
      census_employees = CensusEmployee.where(:"hired_on" => date).non_terminated
      census_employees.each do |ce|
        begin
          Invitation.invite_future_employee_for_open_enrollment!(ce)
        rescue Exception => e
          puts "Unable to deliver open enrollment notice to #{ce.full_name} due to --- #{e}" unless Rails.env.test?
        end
      end
    end

    def terminate_scheduled_census_employees(as_of_date = TimeKeeper.date_of_record)
      census_employees_for_termination = CensusEmployee.pending.where(:employment_terminated_on.lt => as_of_date)
      census_employees_for_termination.each do |census_employee|
        begin
          census_employee.terminate_employment(census_employee.employment_terminated_on)
        rescue Exception => e
          puts "Error while terminating cesus employee - #{census_employee.full_name} due to -- #{e}" unless Rails.env.test?
        end
      end
    end

    def rebase_newly_designated_employees
      return unless TimeKeeper.date_of_record.yday == 1
      CensusEmployee.where(:"aasm_state".in => NEWLY_DESIGNATED_STATES).each do |employee|
        begin
          employee.rebase_new_designee! if employee.may_rebase_new_designee?
        rescue Exception => e
          puts "Error while rebasing newly designated cesus employee - #{employee.full_name} due to #{e}" unless Rails.env.test?
        end
      end
    end

    def terminate_future_scheduled_census_employees(as_of_date)
      census_employees_for_termination = CensusEmployee.where(:aasm_state => "employee_termination_pending").select { |ce| ce.employment_terminated_on <= as_of_date}
      census_employees_for_termination.each do |census_employee|
        begin
          census_employee.terminate_employee_role!
        rescue Exception => e
          puts "Error while terminating future scheduled cesus employee - #{census_employee.full_name} due to #{e}" unless Rails.env.test?
        end
      end
    end

    def census_employee_open_enrollment_reminder_notice(date)
      organizations = Organization.where(:"employer_profile.plan_years" => {:$elemMatch => {:aasm_state.in => ["enrolling", "renewing_enrolling"], :open_enrollment_end_on => date+2.days}})
      organizations.each do |org|
        plan_year = org.employer_profile.plan_years.where(:aasm_state.in => ["enrolling", "renewing_enrolling"]).first
        #exclude congressional employees
        next if plan_year.benefit_groups.any?{|bg| bg.is_congress?}
        census_employees = org.employer_profile.census_employees.non_terminated
        census_employees.each do |ce|
          begin
            #exclude new hires
            next if (ce.new_hire_enrollment_period.cover?(date) || ce.new_hire_enrollment_period.first > date)
            ShopNoticesNotifierJob.perform_later(ce.id.to_s, "employee_open_enrollment_reminder")
          rescue Exception => e
            puts "Unable to deliver open enrollment reminder notice to #{ce.full_name} due to #{e}" unless Rails.env.test?
          end
        end
      end
    end

    def find_all_by_employee_role(employee_role)
      unscoped.where(employee_role_id: employee_role._id)
    end

    def find_all_by_benefit_group(benefit_group)
      unscoped.where("benefit_group_assignments.benefit_group_id" => benefit_group._id)
    end

    def find_all_terminated(employer_profiles: [], date_range: (TimeKeeper.date_of_record..TimeKeeper.date_of_record))

      if employer_profiles.size > 0
        employer_profile_ids = employer_profiles.map(&:_id)
        query = unscoped.terminated.any_in(employer_profile_id: employer_profile_ids).
                                    where(
                                      :employment_terminated_on.gte => date_range.first,
                                      :employment_terminated_on.lte => date_range.last
                                    )
      else
        query = unscoped.terminated.where(
                                    :employment_terminated_on.gte => date_range.first,
                                    :employment_terminated_on.lte => date_range.last
                                  )
      end
      query.to_a
    end

    # Update CensusEmployee records when Person record is updated. (SSN / DOB change)
    def update_census_employee_records(person, current_user)
      person.employee_roles.each do |employee_role|
        ce = employee_role.census_employee
        if current_user.has_hbx_staff_role? && ce.present?
          ce.ssn = person.ssn
          ce.dob = person.dob
          ce.save!(validate: false)
        end
      end
    end

    # Search query string on census employee with first name,last name,SSN.
    def search_hash(s_rex)
      clean_str = s_rex.strip.split.map{|i| Regexp.escape(i)}.join("|")
      action = s_rex.strip.split.size > 1 ? "$and" : "$or"
      search_rex = Regexp.compile(clean_str, true)
      {
          "$or" => [
              {action => [
                  {"first_name" => search_rex},
                  {"last_name" => search_rex}
              ]},
              {"encrypted_ssn" => encrypt_ssn(clean_str)}
          ]
      }
    end
  end

  def self.roster_import_fallback_match(f_name, l_name, dob, bg_id)
    fname_exp = Regexp.compile(Regexp.escape(f_name), true)
    lname_exp = Regexp.compile(Regexp.escape(l_name), true)
    self.where({
      first_name: fname_exp,
      last_name: lname_exp,
      dob: dob
    }).any_in("benefit_group_assignments.benefit_group_id" => [bg_id])
  end

  def self.to_csv
    attributes = %w{employee_name dob hired status renewal_benefit_package benefit_package enrollment_status termination_date}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |census_employee|
        data = [
          "#{census_employee.first_name} #{census_employee.middle_name} #{census_employee.last_name} ",
          census_employee.dob,
          census_employee.hired_on,
          census_employee.aasm_state.humanize.downcase,
          census_employee.renewal_benefit_group_assignment.try(:benefit_group).try(:title)
        ]

        if active_assignment = census_employee.active_benefit_group_assignment
          data += [
            active_assignment.benefit_group.title,
            "dental: #{ d = active_assignment.try(:hbx_enrollments).detect{|enrollment| enrollment.coverage_kind == 'dental'}.try(:aasm_state).try(:humanize).try(:downcase)} health: #{ active_assignment.try(:hbx_enrollments).detect{|enrollment| enrollment.coverage_kind == 'health'}.try(:aasm_state).try(:humanize).try(:downcase)}"
          ]
        else
          data += [nil, nil]
        end
        csv << (data + [census_employee.coverage_terminated_on])
      end
    end
  end

  def existing_cobra
    COBRA_STATES.include? aasm_state
  end

  def existing_cobra=(cobra)
    self.aasm_state = 'cobra_eligible' if cobra == 'true'
  end

  def is_cobra_status?
    existing_cobra
  end

  def can_elect_cobra?
    ['employment_terminated'].include?(aasm_state)
  end

  def have_valid_date_for_cobra?(current_user = nil)
    return true if current_user.try(:has_hbx_staff_role?)
    return false unless cobra_begin_date.present?
    return false unless coverage_terminated_on
    return false unless coverage_terminated_on <= cobra_begin_date

    (hired_on <= cobra_begin_date) &&
      (TimeKeeper.date_of_record <= (coverage_terminated_on + aca_shop_market_cobra_enrollment_period_in_months.months)) &&
      cobra_begin_date <= (coverage_terminated_on + aca_shop_market_cobra_enrollment_period_in_months.months)
  end

  def has_employee_role_linked?
    employee_role.present?
  end

  # should disable cobra
  # 1.waived
  # 2.do not have an enrollment
  # 3.census_employee is pending
  def is_disabled_cobra_action?
    employee_role.blank? || active_benefit_group_assignment.blank? || active_benefit_group_assignment.coverage_waived? ||
      (active_benefit_group_assignment.hbx_enrollment.blank? && active_benefit_group_assignment.hbx_enrollments.blank?) ||
      employee_termination_pending?
  end

  def has_cobra_hbx_enrollment?
    return false if active_benefit_group_assignment.blank? || active_benefit_group_assignment.hbx_enrollment.blank?
    active_benefit_group_assignment.hbx_enrollment.is_cobra_status?
  end

  def need_update_hbx_enrollment_effective_on?
    !has_cobra_hbx_enrollment? && coverage_terminated_on.present?
  end

  def show_plan_end_date?
    is_inactive? && coverage_terminated_on.present?
  end

  def enrollments_for_display
    enrollments = []

    coverages_selected = lambda do |benefit_group_assignment|
      return [] if benefit_group_assignment.blank?
      coverages = benefit_group_assignment.active_and_waived_enrollments.reject{|e| e.external_enrollment }
      [coverages.detect{|c| c.coverage_kind == 'health'}, coverages.detect{|c| c.coverage_kind == 'dental'}]
    end

    enrollments += coverages_selected.call(active_benefit_group_assignment)
    enrollments += coverages_selected.call(renewal_benefit_group_assignment)
    enrollments.compact.uniq
  end


  def expected_to_enroll?
    expected_selection == 'enroll'
  end

  def expected_to_enroll_or_valid_waive?
    %w(enroll waive).include?  expected_selection
  end

  private

  def set_autocomplete_slug
    return unless (first_name.present? && last_name.present?)
    @autocomplete_slug = first_name.concat(" #{last_name}")
  end

  def has_no_hbx_enrollments?
    return true if employee_role.blank?
    !benefit_group_assignments.detect { |bga| bga.hbx_enrollment.present? }
  end

  def check_employment_terminated_on
    return false if is_cobra_status?

    if employment_terminated_on && employment_terminated_on <= hired_on
      errors.add(:employment_terminated_on, "can't occur before hiring date")
    end

    if !self.employment_terminated? && !self.rehired?
      if employment_terminated_on && employment_terminated_on <= TimeKeeper.date_of_record - 60.days
        errors.add(:employment_terminated_on, "Employee termination must be within the past 60 days")
      end
    end
  end

  def check_cobra_begin_date
    if existing_cobra && hired_on > cobra_begin_date
      errors.add(:cobra_begin_date, 'must be after Hire Date')
    end
  end

  def no_duplicate_census_dependent_ssns
    dependents_ssn = census_dependents.map(&:ssn).select(&:present?)
    if dependents_ssn.uniq.length != dependents_ssn.length ||
       dependents_ssn.any?{|dep_ssn| dep_ssn==self.ssn}
      errors.add(:base, "SSN's must be unique for each dependent and subscriber")
    end
  end

  def active_census_employee_is_unique
    potential_dups = CensusEmployee.by_ssn(ssn).by_employer_profile_id(employer_profile_id).active
    if potential_dups.detect { |dup| dup.id != self.id  }
      message = "Employee with this identifying information is already active. "\
                "Update or terminate the active record before adding another."
      errors.add(:base, message)
    end
  end

  def check_census_dependents_relationship
    return true if census_dependents.blank?

    relationships = census_dependents.map(&:employee_relationship)
    if relationships.count{|rs| rs=='spouse' || rs=='domestic_partner'} > 1
      errors.add(:census_dependents, "can't have more than one spouse or domestic partner.")
    end
  end

  # SSN and DOB values may be edited only in pre-linked status
  def allow_id_info_changes_only_in_eligible_state
    if (ssn_changed? || dob_changed?) && !ELIGIBLE_STATES.include?(aasm_state)
      message = "An employee's identifying information may change only when in 'eligible' status. "
      errors.add(:base, message)
    end
  end

  def check_hired_on_before_dob
    if hired_on && dob && hired_on <= dob
      errors.add(:hired_on, "date can't be before  date of birth.")
    end
  end

  def clear_employee_role
    # employee_role.
    self.employee_role_id = nil
    unset("employee_role_id")
    self.benefit_group_assignments = []
    @employee_role = nil
  end

  def notify_terminated
    notify(EMPLOYEE_TERMINATED_EVENT_NAME, { :census_employee_id => self.id } )
  end

  def notify_cobra_terminated
    notify(EMPLOYEE_COBRA_TERMINATED_EVENT_NAME, { :census_employee_id => self.id } )
  end
end

class CensusEmployeeError < StandardError; end
