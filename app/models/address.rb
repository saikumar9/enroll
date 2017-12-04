# Embedded model that stores a location address
class Address
  include LocationModelConcerns::AddressConcern

  embedded_in :person
  embedded_in :census_member, class_name: "CensusMember"
end
