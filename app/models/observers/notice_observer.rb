module Observers
  class NoticeObserver < Observer

    PLANYEAR_NOTICE_EVENTS = [
      :renewal_application_created,
      :initial_application_submitted,
      :renewal_application_submitted,
      :renewal_application_autosubmitted,
      :ineligible_initial_application_submitted,
      :ineligible_renewal_application_submitted,
      :open_enrollment_began,
      :open_enrollment_ended,
      :application_denied
    ]
  
    def plan_year_update(new_model_event)
      raise ArgumentError.new("expected ModelEvents::ModelEvent") unless new_model_event.is_a?(ModelEvents::ModelEvent)

      if PLANYEAR_NOTICE_EVENTS.include?(new_model_event.event_key)
        plan_year = new_model_event.klass_instance

        if new_model_event.event_key == :intial_application_submitted
        end

        if new_model_event.event_key == :ineligible_initial_application_submitted
          eligibility_warnings = plan_year.application_eligibility_warnings

          # if (eligibility_warnings.include?(:primary_office_location) || eligibility_warnings.include?(:fte_count))
            trigger_notice(recipient: plan_year.employer_profile, event_object: plan_year, notice_event: "initial_employer_denial")
          # end
        end

        if new_model_event.event_key == :ineligible_renewal_application_submitted && plan_year.application_eligibility_warnings.include?(:primary_office_location)
          trigger_notice(recipient: plan_year.employer_profile, event_object: plan_year, notice_event: "employer_renewal_eligibility_denial_notice")
          self.employer_profile.census_employees.non_terminated.each do |ce|
            trigger_notice(ce.id.to_s, "termination_of_employers_health_coverage")
          end
        end

      end
    end

    def employer_profile_update; end
    def hbx_enrollment_update; end
    def census_employee_update; end
  end
end