module Calendars
  class ScheduledEventException
    include Mongoid::Document

    field :time, type: Time
    
    embedded_in :scheduled_event, class_name: "Calendars::ScheduledEvent"

    validates_presence_of :time
  end
end
