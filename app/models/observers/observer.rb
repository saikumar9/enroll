require "Observer"
class Observers::Observer
  include Observable

  attr_reader :event_name, :obj, :options

  # "update" is the generic Observable event notification hook method name.
  # By convention, event notification method names will be prepended with the 
  # class name, e.g. employer_profile_update

  def update(event_name, obj, options = {})
    @event_name = event_name
    @obj = obj

    options.each { |k, v| @k = v }
  end

private
  def parse_event(event)
    
  end

end
