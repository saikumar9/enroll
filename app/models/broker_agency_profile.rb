class BrokerAgencyProfile
  include BrokerModelConcerns::BrokerAgencyProfileConcern
  include SetCurrentUser

  has_many :broker_agency_contacts, class_name: "Person", inverse_of: :broker_agency_contact
  accepts_nested_attributes_for :broker_agency_contacts, reject_if: :all_blank, allow_destroy: true

  # has_many employers
  def employer_clients
    return unless (MARKET_KINDS - ["individual"]).include?(market_kind)
    return @employer_clients if defined? @employer_clients
    @employer_clients = EmployerProfile.find_by_broker_agency_profile(self)
  end

  # TODO: has_many families
  def family_clients
    return unless (MARKET_KINDS - ["shop"]).include?(market_kind)
    return @family_clients if defined? @family_clients
    @family_clients = Family.by_broker_agency_profile_id(self.id)
  end

  # alias for broker_roles
  def writing_agents
    active_broker_roles
  end

  # alias for broker_roles - deprecate
  def brokers
    active_broker_roles
  end

  def phone
    office = organization.primary_office_location
    office && office.phone.to_s
  end

  def is_active?
    self.is_approved?
  end

  def linked_employees
    employer_profiles = EmployerProfile.find_by_broker_agency_profile(self)
    emp_ids = employer_profiles.map(&:id)
    linked_employees = Person.where(:'employee_roles.employer_profile_id'.in => emp_ids)
  end

  def families
    linked_active_employees = linked_employees.select{ |person| person.has_active_employee_role? }
    employee_families = linked_active_employees.map(&:primary_family).to_a
    consumer_families = Family.by_broker_agency_profile_id(self.id).to_a
    families = (consumer_families + employee_families).uniq
    families.sort_by{|f| f.primary_applicant.person.last_name}
  end
end
