module Consumer::EmployeeRolesHelper
  def employee_role_submission_options_for(model)
    if model.persisted?
      { :url => consumer_employee_path(model), :method => :put }
    else
      { :url => consumer_employee_index_path, :method => :post }
    end
  end

  def coverage_relationship_check(offered_relationship_benefits=[], family_member)
    relationship = PlanCostDecorator.benefit_relationship(family_member.primary_relationship)

    if relationship == "child_under_26" and calculate_age_by_dob(family_member.dob) > 26
      relationship = "child_over_26"
    end

    offered_relationship_benefits.include? relationship
  end

  def calculate_age_by_dob(dob)
    now = Date.today
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end
end
