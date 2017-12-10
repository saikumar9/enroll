class CensusMember
  include CoreModelConcerns::CensusMemberConcern

  field :employee_relationship, type: String
  field :employer_assigned_family_id, type: String

  validates_presence_of :employee_relationship
end
