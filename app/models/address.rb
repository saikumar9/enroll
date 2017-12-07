# Embedded model that stores a location address
class Address
  include CoreModelConcerns::AddressCoreConcern

  embedded_in :census_member, class_name: "CensusMember"
end
