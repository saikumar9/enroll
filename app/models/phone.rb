class Phone
  include CoreModelConcerns::PhoneCoreConcern
  embedded_in :census_member, class_name: "CensusMember"
end
