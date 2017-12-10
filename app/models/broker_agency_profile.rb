class BrokerAgencyProfile
  include BrokerModelConcerns::BrokerAgencyProfileConcern
  include ShopModelConcerns::BrokerAgencyProfileShopConcern
  include SetCurrentUser

  has_many :broker_agency_contacts, class_name: "Person", inverse_of: :broker_agency_contact
  accepts_nested_attributes_for :broker_agency_contacts, reject_if: :all_blank, allow_destroy: true

  # TODO: has_many families
  def family_clients
    return unless (MARKET_KINDS - ["shop"]).include?(market_kind)
    return @family_clients if defined? @family_clients
    @family_clients = Family.by_broker_agency_profile_id(self.id)
  end

  def is_active?
    self.is_approved?
  end

  def families
    linked_active_employees = linked_employees.select{ |person| person.has_active_employee_role? }
    employee_families = linked_active_employees.map(&:primary_family).to_a
    consumer_families = Family.by_broker_agency_profile_id(self.id).to_a
    families = (consumer_families + employee_families).uniq
    families.sort_by{|f| f.primary_applicant.person.last_name}
  end
end
