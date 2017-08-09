class Observers::ObserverEvent

  attr_reader :event_key, :obj, :options

  def initialize(event_key, obj, options = {})
    @event_key = event_key
    @obj = obj
  end

end
