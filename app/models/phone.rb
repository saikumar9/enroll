class Phone
  include LocationModelConcerns::PhoneConcern
  embedded_in :person
  embedded_in :census_member, class_name: "CensusMember"
end
