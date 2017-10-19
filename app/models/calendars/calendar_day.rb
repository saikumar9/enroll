# This class collects, categorizes and filters {ScheduledEvent ScheduledEvents} for a specific day of the year.
# It provides convenience methods for determining if the day is a holiday, business or weekend day,
# and accesses scheduled events by kind (category) or name

module Calendars
  class CalendarDay

    attr_reader :today

    def initialize(new_date)
      # raise ArgumentError unless new_date.is_a?(Date)
      @today = new_date.beginning_of_day
    end

    # Get the list of all events scheduled on this day
    #
    # @example Get the list of all {ScheduledEvent ScheduledEvents} on this day
    #   calendar_day.scheduled_events
    #
    #  @return [ Array<ScheduledEvent> ] All {ScheduledEvent ScheduledEvents} on this day
    def scheduled_events
      ScheduledEvent.events_for(@today)
    end


    # Get the list of events scheduled on this day which match the passed event_name
    #
    # @param event_name [ String ] event_name text value to match
    #
    # @example Get the list of {ScheduledEvent ScheduledEvents} on this day which match the passed event_name
    #   calendar_day.scheduled_events_for(event_name)
    #
    #  @return [ Array<ScheduledEvent> ] {ScheduledEvent ScheduledEvents} on this date which match the passed event_name
    def scheduled_events_for(event_name)
      scheduled_events.select {|event| event.event_name == event_name }
    end


    # Indicate if this day falls on a Saturday or Sunday
    #
    # @example Does this day fall on the weekend?
    #   calendar_day.is_weekend?
    #
    # @return [ true, false ] true if this day of week is Saturday or Sunday, false if Monday through Friday
    def is_weekend?
      @today.saturday? || @today.sunday?
    end


    # Indicate if any event scheduled on this day is a holiday
    #
    # @example Is this day a holiday?
    #   calendar_day.is_holiday?
    #
    # @return [ true, false ] true if at least one of this day's {ScheduledEvent ScheduledEvents} is a holiday, false otherwise
    def is_holiday?
      holiday_events.size > 0
    end


    # Indicate if this day is business day.  Business days are weekdays that are not holidays 
    #
    # @example Is this day a business day?
    #   calendar_day.is_business_day?
    #
    # @return [ true, false ] true if the day of week is Monday through Friday, and no {ScheduledEvent ScheduledEvents} are a holiday; false otherwise
    def is_business_day?
      !is_weekend? && !is_holiday?
    end


    # Get the list of events scheduled on this day which are holidays
    #
    # @example Get the list of {ScheduledEvent ScheduledEvents} on this day which are holiday kind
    #   calendar_day.holiday_events
    #
    #  @return [ Array<ScheduledEvent> ] {ScheduledEvent ScheduledEvents} on this day which are holiday kind
    def holiday_events
      scheduled_events.select {|event| event.kind == "holiday" }
    end


    # Get the list of events scheduled on this day which are system events
    #
    # @example Get the list of {ScheduledEvent ScheduledEvents} on this day which are system kind
    #   calendar_day.holiday_events
    #
    #  @return [ Array<ScheduledEvent> ] {ScheduledEvent ScheduledEvents} on this day which are system kind
    def system_events
      scheduled_events.select {|event| event.kind == "system" }
    end

  end
end
