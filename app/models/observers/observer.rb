require "Observer"
class Observers::Observer
  include Observable

  EVENTS = [
    advance_day:          { models: [:time_keeper], settings_key: nil,  },
    state_change:         { }, 
    broker_agency_change: { }, 
    general_agent_change: { },
    benefit_period_start: { models: [:employer_profile] },
  ]

  attr_reader :event_name, :klass_instance, :options

  # "update" is the generic Observable event notification hook method name.
  # By convention, event notification method names will be prepended with the 
  # class name, e.g. employer_profile_update

  def update(event_name, klass_instance, options = {})
    @event_name = event_name
    @klass_instance = klass_instance

    options.each { |k, v| @k = v }
  end

private
  def parse_event(event)
    
  end

end
