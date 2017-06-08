class ApplicationEventPublisher

  def initialize(event, options = {})
    @event    = event
    @options  = options
  end

  def save
    @event.save && log_event && publish_event
  end

private
  def log_event
  end
    
  def publish_event
    Acapi.post(kind: @event.kind, instance: @event.instance)
  end
end