module Calendars
  class Calendar
    include Mongoid::Document
    include Mongoid::Timestamps

    field :title, type: String

    has_many :scheduled_events, class_name: "::ScheduledEvent"

    def add_scheduled_event(new_scheduled_event)
      raise ArgumentError.new("expected ScheduledEvent") unless new_scheduled_event.is_a? ScheduledEvent

    end

    def remove_scheduled_event(scheduled_event)
    end

    def edit_scheduled_event(scheduled_event)
    end

  end
end
