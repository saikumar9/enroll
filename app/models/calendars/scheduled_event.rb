module Calendars
  class ScheduledEvent
    include Mongoid::Document
    include Mongoid::Timestamps
    include ScheduledEventService

    field :site_key,              type: Symbol
    field :market_kind,           type: Symbol
    field :settings_key,          type: String

    field :key,                   type: Symbol
    field :title,                 type: String
    field :description,           type: String
    field :recurring,             type: Hash
    field :start_time,            type: Time,     default: TimeKeeper.datetime_of_record
    field :is_holiday,            type: Boolean,  default: false
    field :business_day_offset,   type: Integer,  default: 0
    field :is_business_day_only,  type: Integer,  default: false

    index({key: 1})
    index({site_key: 1, market_kind: 1})

    scope :events_for,  ->(date = TimeKeeper.date_of_record) { where(:start_time => date) }

    embeds_many :scheduled_event_exceptions, 
                class_name: "Calendars::ScheduledEventException",
                validate: true

    validates_presence_of :key, :start_time, :recurring, :is_holiday, message: "required field missing"

    SYSTEM_EVENT_KINDS = [
        { 
            site_key: :mhc, 
            market_kind: :aca_shop, 
            key: :initial_application_due_on,
            recurring: IceCube::Rule.monthly.day_of_month(Settings.aca.shop_market.initial_application.due_on.day_of_month), 
          },

        { 
            site_key: :mhc, 
            market_kind: :aca_shop, 
            recurring: IceCube::Rule.monthly.day_of_month(Settings.aca.shop_market.renewal_application.due_on.day_of_month), 
            key: :renewal_application_due_on,
           },

        { 
            site_key: :mhc, 
            market_kind: :aca_shop, 
            recurring: IceCube::Rule.monthly.day_of_month(Settings.aca.shop_market.renewal_application.create_on.day_of_month), 
            key: :renewal_application_create_on,
           },

        { 
            site_key: :mhc, 
            market_kind: :aca_shop, 
            recurring: IceCube::Rule.monthly.day_of_month(Settings.aca.shop_market.renewal_application.autosubmit_on.day_of_month), 
            key: :renewal_application_autosubmit_on,
           },

        { 
            site_key: :mhc, 
            market_kind: :aca_shop, 
            recurring: IceCube::Rule.monthly.day_of_month(Settings.aca.shop_market.open_enrollment.begin_on.day_of_month), 
            key: :open_enrollment_begin_on,
           },

        { 
            site_key: :mhc, 
            market_kind: :aca_shop, 
            recurring: IceCube::Rule.monthly.day_of_month(Settings.aca.shop_market.open_enrollment.end_on.day_of_month), 
            key: :open_enrollment_end_on
           },
        { 
            site_key: :mhc, 
            market_kind: :aca_shop, 
            recurring: IceCube::Rule.monthly.day_of_month(Settings.aca.shop_market.binder_payment.due_on.day_of_month), 
            key: :binder_payment_due_on,
           },

        { 
            site_key: :mhc, 
            market_kind: :aca_shop, 
            recurring: IceCube::Rule.monthly.day_of_month(Settings.aca.shop_market.group_file.new_employers_group_file.due_on.day_of_month), 
            key: :new_employers_group_file_due_on,
           },

        { 
            site_key: :mhc, 
            market_kind: :aca_shop, 
            recurring: IceCube::Rule.weekly.day(Settings.aca.shop_market.employer_group_update_file.transmit_on.day_of_week), 
            key: :employer_group_update_file_transmit_on,
           },

        { 
            site_key: :dchbx, 
            market_kind: :aca_individual, 
            recurring: IceCube::Rule.yearly.month_of_year(Settings.aca.individual_market.open_enrollment.begin_on.month_of_year).day_of_month(Settings.aca.individual_market.individual_market.open_enrollment.begin_on.day_of_month), 
            key: :open_enrollment_begin,
           },

        { 
            site_key: :dchbx, 
            market_kind: :aca_individual, 
            recurring: IceCube::Rule.yearly.month_of_year(Settings.aca.individual_market.open_enrollment.end_on.month_of_year).day_of_month(Settings.aca.individual_market.open_enrollment.end_on.day_of_month), 
            key: :open_enrollment_end,
           },
           
        {
            site_key: :opm, 
            market_kind: :fehb, 
            recurring: IceCube::Rule.yearly.month_of_year(Settings.opm.fehb.open_enrollment.begin_on.month_of_year).day_of_month(Settings.opm.fehb.individual_market.open_enrollment.begin_on.day_of_month), 
            key: :open_enrollment_begin,
           },

        { 
            site_key: :opm, 
            market_kind: :fehb, 
            recurring: IceCube::Rule.yearly.month_of_year(Settings.opm.fehb.open_enrollment.end_on.month_of_year).day_of_month(Settings.opm.fehb.open_enrollment.end_on.day_of_month), 
            key: :open_enrollment_end,
           },
      ]

    HOLIDAY_EVENT_KINDS = [
        { site_key: :any,   market_kind: :any,  recurring: {},                              key: :new_years_day_observed,  title: "New Year's Day (observed)", },
        { site_key: :any,   market_kind: :any,  recurring: IceCube::Rule.yearly.month_of_year(:february).day_of_week(monday: [3]),    key: :martin_luther_king_day,  title: "Martin Luther King, Jr. Day", },
        { site_key: :any,   market_kind: :any,  recurring: IceCube::Rule.yearly.month_of_year(:january).day_of_week(monday: [3]),     key: :washingtons_birthday,    title: "Washington’s Birthday", },
        { site_key: :any,   market_kind: :any,  recurring: IceCube::Rule.yearly.month_of_year(:may).day_of_week(monday: [-1]),        key: :memorial_day,            title: "Memorial Day", },
        { site_key: :any,   market_kind: :any,  recurring: {},                              key: :independence_day_observed,  title: "Independence Day (observed)", },
        { site_key: :any,   market_kind: :any,  recurring: IceCube::Rule.yearly.month_of_year(:september).day_of_week(monday: [1]),   key: :labor_day,               title: "Labor Day", },
        { site_key: :any,   market_kind: :any,  recurring: IceCube::Rule.yearly.month_of_year(:october).day_of_week(monday: [2]),     key: :columbus_day,            title: "Columbus Day", },
        { site_key: :any,   market_kind: :any,  recurring: {},                              key: :veterans_day_observed,      title: "Veteran's Day (observed)", },
        { site_key: :any,   market_kind: :any,  recurring: IceCube::Rule.yearly.month_of_year(:november).day_of_week(thursday: [4]),  key: :thanksgiving_day,        title: "Thanksgiving Day", },
        { site_key: :any,   market_kind: :any,  recurring: {},                              key: :christmas_day_observed,           title: "Christmas Day (observed)", },

        { site_key: :dchbx, market_kind: :any,  recurring: {},                              key: :emancipation_day_observed,        title: "Emancipation Day (observed)", },
        # Inauguration Day:  January 20 every 4 years
        { site_key: :dchbx, market_kind: :any,  recurring: IceCube::Rule.yearly(4).month_of_year(:january).day_of_month(20), key: :inauguration_day,        title: "Inauguration Day", },

        { site_key: :mhc,   market_kind: :any,  recurring: IceCube::Rule.yearly.month_of_year(:april).day_of_week(monday: [3]),       key: :patriots_day,            title: "Patriot's Day", },
      ]

    # @shop_market_binder_payment_due_on ||= ScheduledEvent.day_of_month_for("shop_binder_payment_due_on") || Settings.aca.shop_market.binder_payment_due_on


    def holiday_schedule(start_on = Time.utc(2017,1,1)) # 2017-01-1 00:00:00 UTC)
      IceCube::Schedule.new(now = start_on) do |schedule|
        HOLIDAY_EVENT_KINDS.each do |holiday|
          schedule.add_recurrence_rule(holiday.recurring) if recurring.size > 0
          # s.add_exception_time(now + 1.day)
        end
      end
    end

    schedule = IceCube::Schedule.new
    schedule.add_recurrence_rule(
      IceCube::Rule.yearly.day_of_month(13).day(:friday).month_of_year(:october)
    )

  # # Every friday the 13th that falls in October
  # schedule = IceCube::Schedule.new
  # schedule.add_recurrence_rule(
  #   IceCube::Rule.yearly.day_of_month(13).day(:friday).month_of_year(:october)
  # )

  # # every month on the first and last tuesdays of the month
  # schedule.add_recurrence_rule IceCube::Rule.monthly.day_of_week(:tuesday => [1, -1])

  # # every other month on the first monday and last tuesday
  # schedule.add_recurrence_rule IceCube::Rule.monthly(2).day_of_week(
  #   :monday => [1],
  #   :tuesday => [-1]
  # )

  # schedule.add_recurrence_rule IceCube::Rule.monthly.day_of_month(15)

  # schedule.add_recurrence_rule  # Washingtons bday
  # schedule.add_recurrence_rule  # MLK day
  # schedule.add_recurrence_rule  ## patriots day
  # schedule.add_recurrence_rule  ## Memorial Day: Last Monday in May
  # schedule.add_recurrence_rule  # labor day
  # schedule.add_recurrence_rule  # columbus day
  # schedule.add_recurrence_rule  # thanksgiving day

  # schedule.add_recurrence_rule IceCube::Rule.yearly.month_of_year(:may).day_of_week(monday: [-1])
  # schedule.add_recurrence_rule IceCube::Rule.yearly.month_of_year(:may).day_of_week(monday: [-1])

  # # every week on friday
  # schedule.add_recurrence_rule IceCube::Rule.weekly.day(:friday)

  # # every month on the first and last days of the month
  # schedule.add_recurrence_rule IceCube::Rule.monthly.day_of_month(1, -1)

  # # every year on first day of year
  # schedule.add_recurrence_rule IceCube::Rule.yearly.day_of_year(1)


    def rule
      IceCube::Rule.from_hash recurring
    end

    def recurring=(new_rule)
      if RecurringSelect.is_valid_rule?(new_rule)
        super(RecurringSelect.dirty_hash_to_rule(new_rule).to_hash)
      else
        super(nil)
      end
    end

    def schedule(start_at = TimeKeeper.datetime_of_record)
      schedule = IceCube::Schedule.new(start_at)
      schedule.add_recurrence_rule(rule)

      scheduled_event_exceptions.each do |exception|
        schedule.add_exception_time(exception.time)
      end

      schedule
    end

    def calendar_events(start_at)
      if recurring.blank?
        [self]
      else
        end_date = start_at.end_of_month.end_of_week
        schedule(start_at).occurrences(end_date).map do |start_date|
          start_at = offset(start_date)
          ScheduledEvent.new(id: id, key: key, title: title, start_at: start_at)
        end
      end
    end

    def offset(start_at)
      if start_at.saturday?
        business_day_offset.day + 2.days
      elsif start_at.sunday?
        business_day_offset.day + 1.day
      else
        start_at
      end
    end

    def closest_weekday(today)
      (today.saturday?) ? today - 1 : (today.sunday?) ? today + 1 : today
    end

    def soonest_weekday(today)
      (today.saturday?) ? today + 2 : (today.sunday?) ? today + 1 : today
    end


    def self.day_of_month_for(key)    
      begin   
        ScheduledEvent.find_by!(key: key).start_on.day    
      rescue Mongoid::Errors::DocumentNotFound    
         nil   
      end     
    end
  end
end
