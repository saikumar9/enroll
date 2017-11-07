class EmployerProfileAccount
  include EmployerProfileAccountConcern

  embedded_in :employer_profile

  def self.find(id)
    org = Organization.where(:"employer_profile.employer_profile_account._id" => id)
    org.first.employer_profile.employer_profile_account
  end

private
  def is_before_plan_year_start?
    employer_profile.published_plan_year.is_before_start?
  end

  def reinstate_employer
    employer_profile.employer_reinstated!
  end

  def credit_binder
    employer_profile.binder_credited!
  end

  def reverse_binder
    employer_profile.binder_reversed!
  end

  def enroll_employer
    employer_profile.enroll_employer!
  end

  def expire_enrollment
    employer_profile.enrollment_expired!
  end

  def cancel_benefit
    employer_profile.benefit_canceled! if employer_profile.may_benefit_canceled?
  end

  def suspend_benefit
    employer_profile.benefit_suspended!
  end

  def terminate_benefit
    employer_profile.benefit_terminated!
  end


end
