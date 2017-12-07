class OfficeLocation
  include CoreModelConcerns::OfficeLocationCoreConcern

  validate :address_includes_county_for_employers_primary_location

  def address_includes_county_for_employers_primary_location
    return unless is_an_employer?
    if address.kind == 'primary' && address.county.blank?
      self.errors.add(:base, 'Employers must have a valid County for their primary office location')
    end
  end

  def is_an_employer?
    return false if organization.nil?
    organization.employer_profile.present?
  end
end
