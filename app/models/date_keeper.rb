class DateKeeper
  include Singleton

  CACHE_KEY = "datekeeper/scheduled_events"

  def initialize
    @@today = TimeKeeper.date_of_record.to_date
  end

  ## Only TimeKeeper should call this method
  def self.advance_day(new_date)
    @@today = new_date.beginning_of_day
    self.load_todays_scheduled_events
  end

  def self.load_daily_scheduled_events_for(date = @@today)
    @@scheduled_events = ScheduledEvents.events_for(date)
    Rails.cache.write(CACHE_KEY, @@scheduled_events)
  end

  # Get the list of all events scheduled on this day
  #
  # @example Get the list of all {ScheduledEvent ScheduledEvents} on this day
  #   calendar_day.scheduled_events
  #
  #  @return [ Array<ScheduledEvent> ] All {ScheduledEvent ScheduledEvents} on this day
  def self.daily_scheduled_events
    Rails.cache.fetch(CACHE_KEY, expires_in: 24.hours) do
      self.load_daily_scheduled_events_for(@@today)
    end
  end

  # Indicate if this day falls on a Saturday or Sunday
  #
  # @example Does this day fall on the weekend?
  #   calendar_day.is_weekend?
  #
  # @return [ true, false ] true if this day of week is Saturday or Sunday, false if Monday through Friday
  def self.is_weekend?
    @@today.saturday? || @@today.sunday?
  end

  # Indicate if any event scheduled on this day is a holiday
  #
  # @example Is this day a holiday?
  #   calendar_day.is_holiday?
  #
  # @return [ true, false ] true if at least one of this day's {ScheduledEvent ScheduledEvents} is a holiday, false otherwise
  def self.is_holiday?
    self.holiday_events.size > 0
  end


  # Indicate if this day is business day.  Business days are weekdays that are not holidays 
  #
  # @example Is this day a business day?
  #   calendar_day.is_business_day?
  #
  # @return [ true, false ] true if the day of week is Monday through Friday, and no {ScheduledEvent ScheduledEvents} are a holiday; false otherwise
  def self.is_business_day?
    !self.is_weekend? && !self.is_holiday?
  end


  # Get the list of events scheduled on this day which are holidays
  #
  # @example Get the list of {ScheduledEvent ScheduledEvents} on this day which are holiday kind
  #   calendar_day.holiday_events
  #
  #  @return [ Array<ScheduledEvent> ] {ScheduledEvent ScheduledEvents} on this day which are holiday kind
  def self.daily_holiday_events
    @@scheduled_events.collect {|event| event.kind == "holiday" }
  end


  # Get the list of events scheduled on this day which are system events
  #
  # @example Get the list of {ScheduledEvent ScheduledEvents} on this day which are system kind
  #   calendar_day.holiday_events
  #
  #  @return [ Array<ScheduledEvent> ] {ScheduledEvent ScheduledEvents} on this day which are system kind
  def self.daily_system_events
    @@scheduled_events.collect {|event| event.kind == "system" }
  end


end
