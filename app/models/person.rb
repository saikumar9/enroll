class Person
  include CoreModelConcerns::PersonConcern
  include BrokerModelConcerns::PersonBrokerConcern
  include Config::AcaModelConcern
  include Config::SiteModelConcern
  include SetCurrentUser

  include Notify
  include FullStrippedNames

  extend Mongorder
#  validates_with Validations::DateRangeValidator

  PERSON_CREATED_EVENT_NAME = "acapi.info.events.individual.created"
  PERSON_UPDATED_EVENT_NAME = "acapi.info.events.individual.updated"

  embeds_one :consumer_role, cascade_callbacks: true, validate: true
  delegate :is_applying_coverage, to: :consumer_role, allow_nil: true

  # Login account

  belongs_to :employer_contact,
                class_name: "EmployerProfile",
                inverse_of: :employer_contacts,
                index: true

  belongs_to :general_agency_contact,
                class_name: "GeneralAgencyProfile",
                inverse_of: :general_agency_contacts,
                index: true

  embeds_one :resident_role, cascade_callbacks: true, validate: true
  embeds_one :hbx_staff_role, cascade_callbacks: true, validate: true
  #embeds_one :responsible_party, cascade_callbacks: true, validate: true # This model does not exist.

  embeds_one :csr_role, cascade_callbacks: true, validate: true
  embeds_one :assister_role, cascade_callbacks: true, validate: true

  embeds_many :employer_staff_roles, cascade_callbacks: true, validate: true
  embeds_many :broker_agency_staff_roles, cascade_callbacks: true, validate: true
  embeds_many :employee_roles, cascade_callbacks: true, validate: true
  embeds_many :general_agency_staff_roles, cascade_callbacks: true, validate: true


  accepts_nested_attributes_for :consumer_role, :resident_role, :hbx_staff_role,
     :employee_roles, :employer_staff_roles

  validate :no_changing_my_user, :on => :update


  #after_save :generate_family_search

  # Employer role index
  index({"employer_staff_roles._id" => 1})
  index({"employer_staff_roles.employer_profile_id" => 1})

  # Consumer child model indexes
  index({"consumer_role._id" => 1})
  index({"consumer_role.aasm_state" => 1})
  index({"consumer_role.is_active" => 1})

  # Employee child model indexes
  index({"employee_roles._id" => 1})
  index({"employee_roles.employer_profile_id" => 1})
  index({"employee_roles.census_employee_id" => 1})
  index({"employee_roles.benefit_group_id" => 1})
  index({"employee_roles.is_active" => 1})

  # HbxStaff child model indexes
  index({"hbx_staff_role._id" => 1})
  index({"hbx_staff_role.is_active" => 1})

  index({"hbx_employer_staff_role._id" => 1})

  #index({"hbx_responsible_party_role._id" => 1})

  index({"hbx_csr_role._id" => 1})
  index({"hbx_assister._id" => 1})

  scope :all_consumer_roles,          -> { exists(consumer_role: true) }
  scope :all_resident_roles,          -> { exists(resident_role: true) }
  scope :all_employee_roles,          -> { exists(employee_roles: true) }
  scope :all_employer_staff_roles,    -> { exists(employer_staff_roles: true) }

  #scope :all_responsible_party_roles, -> { exists(responsible_party_role: true) }
  scope :all_hbx_staff_roles,         -> { exists(hbx_staff_role: true) }
  scope :all_csr_roles,               -> { exists(csr_role: true) }
  scope :all_assister_roles,          -> { exists(assister_role: true) }

  scope :unverified_persons,        -> { where(:'consumer_role.aasm_state' => { "$ne" => "fully_verified" })}

  scope :general_agency_staff_applicant,     -> { where("general_agency_staff_roles.aasm_state" => { "$eq" => :applicant })}
  scope :general_agency_staff_certified,     -> { where("general_agency_staff_roles.aasm_state" => { "$eq" => :active })}
  scope :general_agency_staff_decertified,   -> { where("general_agency_staff_roles.aasm_state" => { "$eq" => :decertified })}
  scope :general_agency_staff_denied,        -> { where("general_agency_staff_roles.aasm_state" => { "$eq" => :denied })}

#  ViewFunctions::Person.install_queries

  validate :consumer_fields_validations

  after_create :notify_created
  after_update :notify_updated

  def active_general_agency_staff_roles
    general_agency_staff_roles.select(&:active?)
  end

  def contact_addresses
    existing_addresses = addresses.to_a
    home_address = existing_addresses.detect { |addy| addy.kind == "home" }
    return existing_addresses if home_address
    add_employee_home_address(existing_addresses)
  end

  def add_employee_home_address(existing_addresses)
    return existing_addresses unless employee_roles.any?
    employee_contact_address = employee_roles.sort_by(&:hired_on).map(&:census_employee).compact.map(&:address).compact.first
    return existing_addresses unless employee_contact_address
    existing_addresses + [employee_contact_address]
  end

  delegate :citizen_status, :citizen_status=, :to => :consumer_role, :allow_nil => true
  delegate :ivl_coverage_selected, :to => :consumer_role, :allow_nil => true
  delegate :all_types_verified?, :to => :consumer_role

  def notify_created
    notify(PERSON_CREATED_EVENT_NAME, {:individual_id => self.hbx_id } )
  end

  def notify_updated
    notify(PERSON_UPDATED_EVENT_NAME, {:individual_id => self.hbx_id } ) if need_to_notify?
  end

  def need_to_notify?
    changed_fields = changed_attributes.keys
    changed_fields << consumer_role.changed_attributes.keys if consumer_role.present?
    changed_fields << employee_roles.map(&:changed_attributes).map(&:keys) if employee_roles.present?
    changed_fields << employer_staff_roles.map(&:changed_attributes).map(&:keys) if employer_staff_roles.present?
    changed_fields = changed_fields.flatten.compact.uniq
    notify_fields = changed_fields.reject{|field| ["bookmark_url", "updated_at"].include?(field)}
    notify_fields.present?
  end

  def is_aqhp?
    family = self.primary_family if self.primary_family
    if family
      check_households(family) && check_tax_households(family)
    else
      false
    end
  end

  def check_households family
    family.households.present? ? true : false
  end

  def check_tax_households family
    family.households.first.tax_households.present? ? true : false
  end

  def completed_identity_verification?
    return false unless user
    user.identity_verified?
  end

  #after_save :update_family_search_collection

  # before_save :notify_change
  # def notify_change
  #   notify_change_event(self, {"identifying_info"=>IDENTIFYING_INFO_ATTRIBUTES, "address_change"=>ADDRESS_CHANGE_ATTRIBUTES, "relation_change"=>RELATIONSHIP_CHANGE_ATTRIBUTES})
  # end

  def update_family_search_collection
    #  ViewFunctions::Person.run_after_save_search_update(self.id)
  end

  # Get the {Family} where this {Person} is the primary family member
  #
  # family itegrity ensures only one active family can be the primary for a person
  #
  # @return [ Family ] the family member who matches this person
  def primary_family
    @primary_family ||= Family.find_primary_applicant_by_person(self).first
  end

  def families
    Family.find_all_by_person(self)
  end

  # collect all verification types user can have based on information he provided
  def verification_types
    verification_types = []
    verification_types << 'Social Security Number' if ssn
    verification_types << 'American Indian Status' if citizen_status && ::ConsumerRole::INDIAN_TRIBE_MEMBER_STATUS.include?(citizen_status)
    if self.us_citizen
      verification_types << 'Citizenship'
    else
      verification_types << 'Immigration status'
    end
    verification_types
  end

  def add_work_email(email)
    existing_email = self.emails.detect do |e|
      (e.kind == 'work') &&
        (e.address.downcase == email.downcase)
    end
    return nil if existing_email.present?
    self.emails << ::Email.new(:kind => 'work', :address => email)
  end

  def home_email
    emails.detect { |adr| adr.kind == "home" }
  end

  def work_email
    emails.detect { |adr| adr.kind == "work" }
  end

  def work_email_or_best
    email = emails.detect { |adr| adr.kind == "work" } || emails.first
    (email && email.address) || (user && user.email)
  end

  def has_active_consumer_role?
    consumer_role.present? and consumer_role.is_active?
  end

  def has_active_resident_role?
    resident_role.present? and resident_role.is_active?
  end

  def can_report_shop_qle?
    employee_roles.first.census_employee.qle_30_day_eligible?
  end

  def has_active_employee_role?
    active_employee_roles.any?
  end

  def has_employer_benefits?
    active_employee_roles.present? && active_employee_roles.any?{|r| r.benefit_group.present?}
  end

  def active_employee_roles
    employee_roles.select{|employee_role| employee_role.census_employee && employee_role.census_employee.is_active? }
  end

  def has_multiple_active_employers?
    active_census_employees.count > 1
  end

  def active_census_employees
    census_employees = CensusEmployee.matchable(ssn, dob).to_a + CensusEmployee.unclaimed_matchable(ssn, dob).to_a
    ces = census_employees.select { |ce| ce.is_active? }
    (ces + active_employee_roles.map(&:census_employee)).uniq
  end

  def has_active_employer_staff_role?
    employer_staff_roles.present? and employer_staff_roles.active.present?
  end

  def active_employer_staff_roles
    employer_staff_roles.present? ? employer_staff_roles.active : []
  end

  def has_multiple_roles?
    consumer_role.present? && active_employee_roles.present?
  end

  def has_active_employee_role_for_census_employee?(census_employee)
    if census_employee
      (active_employee_roles.detect { |employee_role| employee_role.census_employee == census_employee }).present?
    end
  end

  class << self

    def search_first_name_last_name_npn(s_str, query=self)
      clean_str = s_str.strip
      s_rex = Regexp.new(Regexp.escape(s_str.strip), true)
      query.where({
        "$or" => ([
          {"first_name" => s_rex},
          {"last_name" => s_rex},
          {"broker_role.npn" => s_rex}
          ] + additional_exprs(clean_str))
        })
    end

    # Find all employee_roles.  Since person has_many employee_roles, person may show up
    # employee_role.person may not be unique in returned set
    def employee_roles
      people = exists(:'employee_roles.0' => true).entries
      people.flat_map(&:employee_roles)
    end

    def find_all_brokers_or_staff_members_by_agency(broker_agency)
      Person.or({:"broker_role.broker_agency_profile_id" => broker_agency.id},
                {:"broker_agency_staff_roles.broker_agency_profile_id" => broker_agency.id})
    end

    def sans_primary_broker(broker_agency)
      where(:"broker_role._id".nin => [broker_agency.primary_broker_role_id])
    end

    def find_all_staff_roles_by_employer_profile(employer_profile)
      #where({"$and"=>[{"employer_staff_roles.employer_profile_id"=> employer_profile.id}, {"employer_staff_roles.is_owner"=>true}]})
      staff_for_employer(employer_profile)
    end

    def person_has_an_active_enrollment?(person)
      if !person.primary_family.blank? && !person.primary_family.enrollments.blank?
        person.primary_family.enrollments.each do |enrollment|
          return true if enrollment.is_active
        end
      end
      return false
    end

    def dob_change_implication_on_active_enrollments(person, new_dob)
      # This method checks if there is a premium implication in all active enrollments when a persons DOB is changed.
      # Returns a hash with Key => HbxEnrollment ID and, Value => true if  enrollment has Premium Implication.
      premium_impication_for_enrollment = Hash.new
      active_enrolled_hbxs = person.primary_family.active_household.hbx_enrollments.active.enrolled_and_renewal

      # Iterate over each enrollment and check if there is a Premium Implication based on the following rule:
      # Rule: There are Implications when DOB changes makes anyone in the household a different age on the day coverage started UNLESS the
      #       change is all within the 0-20 age range or all within the 61+ age range (20 >= age <= 61)
      active_enrolled_hbxs.each do |hbx|
        new_temp_person = person.dup
        new_temp_person.dob = Date.strptime(new_dob.to_s, '%m/%d/%Y')
        new_age     = new_temp_person.age_on(hbx.effective_on)  # age with the new DOB on the day coverage started
        current_age = person.age_on(hbx.effective_on)           # age with the current DOB on the day coverage started

        next if new_age == current_age # No Change in age -> No Premium Implication

        # No Implication when the change is all within the 0-20 age range or all within the 61+ age range
        if ( current_age.between?(0,20) && new_age.between?(0,20) ) || ( current_age >= 61 && new_age >= 61 )
          #premium_impication_for_enrollment[hbx.id] = false
        else
          premium_impication_for_enrollment[hbx.id] = true
        end
      end
      premium_impication_for_enrollment
    end

    def brokers_or_agency_staff_with_status(query, status)
      query.and(
                Person.or(
                          { :"broker_agency_staff_roles.aasm_state" => status },
                          { :"broker_role.aasm_state" => status }
                         ).selector
               )
    end

    def staff_for_employer(employer_profile)
      self.where(:employer_staff_roles => {
          '$elemMatch' => {
              employer_profile_id: employer_profile.id,
              aasm_state: :is_active}
          }).to_a
    end

    def staff_for_employer_including_pending(employer_profile)
      self.where(:employer_staff_roles => {
        '$elemMatch' => {
            employer_profile_id: employer_profile.id,
            :aasm_state.ne => :is_closed
        }
        })
    end

    # Adds employer staff role to person
    # Returns status and message if failed
    # Returns status and person if successful
    def add_employer_staff_role(first_name, last_name, dob, email, employer_profile)
      person = Person.where(first_name: /^#{first_name}$/i, last_name: /^#{last_name}$/i, dob: dob)

      return false, 'Person count too high, please contact HBX Admin' if person.count > 1
      return false, 'Person does not exist on the HBX Exchange' if person.count == 0

      employer_staff_role = EmployerStaffRole.create(person: person.first, employer_profile_id: employer_profile._id)
      employer_staff_role.save
      return true, person.first
    end

    # Sets employer staff role to inactive
    # Returns false if person not found
    # Returns false if employer staff role not matches
    # Returns true is role was marked inactive
    def deactivate_employer_staff_role(person_id, employer_profile_id)

      begin
        person = Person.find(person_id)
      rescue
        return false, 'Person not found'
      end
      if role = person.employer_staff_roles.detect{|role| role.employer_profile_id.to_s == employer_profile_id.to_s && !role.is_closed?}
        role.update_attributes!(:aasm_state => :is_closed)
        return true, 'Employee Staff Role is inactive'
      else
        return false, 'No matching employer staff role'
      end
    end

  end ## class method end

  # HACK
  # FIXME
  # TODO: Move this out of here

  attr_accessor :is_consumer_role
  attr_accessor :is_resident_role

  before_save :assign_citizen_status_from_consumer_role

  def assign_citizen_status_from_consumer_role
    if is_consumer_role.to_s=="true"
      assign_citizen_status
    end
  end

  def agent?
    agent = self.csr_role || self.assister_role || self.broker_role || self.hbx_staff_role || self.general_agency_staff_roles.present?
    !!agent
  end

  def contact_info(email_address, area_code, number, extension)
    if email_address.present?
      email = emails.detect{|mail|mail.kind == 'work'}
      if email
        email.update_attributes!(address: email_address)
      else
        email= Email.new(kind: 'work', address: email_address)
        emails.append(email)
        self.update_attributes!(emails: emails)
        save!
      end
    end
    phone = phones.detect{|p|p.kind == 'work'}
    if phone
      phone.update_attributes!(area_code: area_code, number: number, extension: extension)
    else
      phone = Phone.new(kind: 'work', area_code: area_code, number: number, extension: extension)
      phones.append(phone)
      self.update_attributes!(phones: phones)
      save!
    end
  end

  def generate_family_search
    ::MapReduce::FamilySearchForPerson.populate_for(self)
  end

  def set_ridp_for_paper_application(session_var)
    if user && session_var == 'paper'
      user.ridp_by_paper_application
    end
  end

  private

  def no_changing_my_user
    if self.persisted? && self.user_id_changed?
      old_user, new_user= self.user_id_change
      return if old_user.blank?
      if (old_user != new_user)
        errors.add(:base, "you may not change the user_id of a person once it has been set and saved")
      end
    end
  end

  def consumer_fields_validations
    if @is_consumer_role.to_s == "true" #only check this for consumer flow.
      citizenship_validation
      native_american_validation
      incarceration_validation
    end
  end

  def native_american_validation
    self.errors.add(:base, "American Indian / Alaskan Native status is required.") if indian_tribe_member.to_s.blank?
    if !tribal_id.present? && @us_citizen == true && @indian_tribe_member == true
      self.errors.add(:base, "Tribal id is required when native american / alaskan native is selected")
    elsif tribal_id.present? && !tribal_id.match("[0-9]{9}")
      self.errors.add(:base, "Tribal id must be 9 digits")
    end
  end

  def citizenship_validation
    if @us_citizen.to_s.blank?
      self.errors.add(:base, "Citizenship status is required.")
    elsif @us_citizen == false && @eligible_immigration_status.nil?
      self.errors.add(:base, "Eligible immigration status is required.")
    elsif @us_citizen == true && @naturalized_citizen.nil?
      self.errors.add(:base, "Naturalized citizen is required.")
    end
  end

  def incarceration_validation
    self.errors.add(:base, "Incarceration status is required.") if is_incarcerated.to_s.blank?
  end
end
