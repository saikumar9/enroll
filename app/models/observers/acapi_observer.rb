class Observers::AcapiObserver < Observers::Observer
  include Acapi::Notifiers
  extend Acapi::Notifiers

  BINDER_PREMIUM_PAID_EVENT_NAME = "acapi.info.events.employer.binder_premium_paid"
  EMPLOYER_PROFILE_UPDATED_EVENT_NAME = "acapi.info.events.employer.updated"
  INITIAL_APPLICATION_ELIGIBLE_EVENT_TAG="benefit_coverage_initial_application_eligible"
  INITIAL_EMPLOYER_TRANSMIT_EVENT="acapi.info.events.employer.benefit_coverage_initial_application_eligible"
  RENEWAL_APPLICATION_ELIGIBLE_EVENT_TAG="benefit_coverage_renewal_application_eligible"
  RENEWAL_EMPLOYER_TRANSMIT_EVENT="acapi.info.events.employer.benefit_coverage_renewal_application_eligible"


  # TODO
  # method pulled from StateTransitionPublisher
  # integrate or replace here and delete class StateTransitionPublisher
  def publish_transition
    resource_mapping = ApplicationEventMapper.map_resource(self.class)
    event_name = ApplicationEventMapper.map_event_name(resource_mapping, aasm.current_event)
    notify(event_name, {resource_mapping.identifier_key => self.send(resource_mapping.identifier_method).to_s})
  end


  def employer_profile_update(observer_event, employer_profile, options={})
  end

  def time_keeper_update(observer_event, employer_profile, options={})
  end

end
