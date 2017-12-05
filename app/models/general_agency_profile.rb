class GeneralAgencyProfile
  include BrokerModelConcerns::GeneralAgencyProfileConcern
  include SetCurrentUser
  include AgencyProfile

  has_many :general_agency_contacts, class_name: "Person", inverse_of: :general_agency_contact
  accepts_nested_attributes_for :general_agency_contacts, reject_if: :all_blank, allow_destroy: true

  def general_agency_staff_roles
    Person.where("general_agency_staff_roles.general_agency_profile_id" => BSON::ObjectId.from_string(self.id)).map {|p| p.general_agency_staff_roles.detect {|s| s.general_agency_profile_id == id}}
  end

  def phone
    office = organization.primary_office_location
    office && office.phone.to_s
  end

  def linked_employees
    employer_profiles = EmployerProfile.find_by_general_agency_profile(self)
    emp_ids = employer_profiles.map(&:id)
    linked_employees = Person.where(:'employee_roles.employer_profile_id'.in => emp_ids)
  end

  def families
    employee_families = linked_employees.map(&:primary_family).to_a
    families = employee_families.uniq.compact
    families.sort_by{|f| f.primary_applicant.person.last_name}
  end

  def employer_clients_count
    employer_clients.present? ? employer_clients.count : 0
  end

  # general_agency should have only one general_agency_staff_role
  def primary_staff
    general_agency_staff_roles.present? ? general_agency_staff_roles.last : nil
  end

  def current_staff_state
    primary_staff.current_state rescue ""
  end

  class << self

    def all_by_broker_role(broker_role, options={})
      favorite_general_agency_ids = broker_role.favorite_general_agencies.map(&:general_agency_profile_id) rescue []
      all_ga = if options[:approved_only]
                 all.select{|ga| ga.aasm_state == 'is_approved'}
               else
                 all
               end

      if favorite_general_agency_ids.present?
        all_ga.sort {|ga| favorite_general_agency_ids.include?(ga.id) ? 0 : 1 }
      else
        all_ga
      end
    end
  end
end
