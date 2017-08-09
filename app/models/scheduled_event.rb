class ScheduledEvent
  include Mongoid::Document
  include Mongoid::Timestamps
  include ScheduledEventService

  KINDS = [:system, :holiday]
  SYSTEM_EVENT_KINDS = [
        { site_key: :mhc,   market_kind: :aca_shop, recurring_rules: {}, kind: :system, key: :initial_application_due,           settings_key: 'Settings.aca.shop_market.initial_application.publish_due_date_of_month' },
        { site_key: :mhc,   market_kind: :aca_shop, recurring_rules: {}, kind: :system, key: :renewal_application_due,           settings_key: 'Settings.aca.shop_market.renewal_application.publish_due_date_of_month' },
        { site_key: :mhc,   market_kind: :aca_shop, recurring_rules: {}, kind: :system, key: :renewal_application_autosubmitted, settings_key: 'Settings.aca.shop_market.renewal_application.force_publish_day_of_month' },
        { site_key: :mhc,   market_kind: :aca_shop, recurring_rules: {}, kind: :system, key: :open_enrollment_begin,             settings_key: 'Settings.aca.shop_market.open_enrollment.monthly_start_on' },
        { site_key: :mhc,   market_kind: :aca_shop, recurring_rules: {}, kind: :system, key: :open_enrollment_end,               settings_key: 'Settings.aca.shop_market.open_enrollment.monthly_end_on' },
        { site_key: :mhc,   market_kind: :aca_shop, recurring_rules: {}, kind: :system, key: :binder_payment_due,                settings_key: 'Settings.aca.shop_market.binder_payment_due_on' },
        { site_key: :mhc,   market_kind: :aca_shop, recurring_rules: {}, kind: :system, key: :new_employers_group_file_due,      settings_key: 'Settings.aca.shop_market.group_file.new_enrollment_transmit_on' },
        { site_key: :mhc,   market_kind: :aca_shop, recurring_rules: { rule: IceCube::Rule.weekly.day(:friday) }, kind: :system, key: :employer_group_file_update_due,    settings_key: 'Settings.aca.shop_market.group_file.update_transmit_day_of_week' },
      ]

  HOLIDAY_EVENT_KINDS = [
      { site_key: :any,   market_kind: :any,  recurring_rules: {},                              kind: :holiday, key: :new_years_day,           title: "New Year's Day", },
      { site_key: :any,   market_kind: :any,  recurring_rules: {},                              kind: :holiday, key: :new_years_day_observed,  title: "New Year's Day (observed)", },
      { site_key: :any,   market_kind: :any,  recurring_rules: { rule: IceCube::Rule.yearly.month_of_year(:february).day_of_week(monday: [3]) },     kind: :holiday, key: :martin_luther_king_day,  title: "Martin Luther King, Jr. Day", },
      { site_key: :any,   market_kind: :any,  recurring_rules: { rule: IceCube::Rule.yearly.month_of_year(:january).day_of_week(monday: [3]) },    kind: :holiday, key: :washingtons_birthday,    title: "Washington’s Birthday", },
      { site_key: :any,   market_kind: :any,  recurring_rules: { rule: IceCube::Rule.yearly.month_of_year(:may).day_of_week(monday: [-1]) },          kind: :holiday, key: :memorial_day,            title: "Memorial Day", },
      { site_key: :any,   market_kind: :any,  recurring_rules: {},                              kind: :holiday, key: :independence_day,        title: "Independence Day", },
      { site_key: :any,   market_kind: :any,  recurring_rules: {},                              kind: :holiday, key: :independence_day_observed,  title: "Independence Day (observed)", },
      { site_key: :any,   market_kind: :any,  recurring_rules: { rule: IceCube::Rule.yearly.month_of_year(:september).day_of_week(monday: [1]) },   kind: :holiday, key: :labor_day,               title: "Labor Day", },
      { site_key: :any,   market_kind: :any,  recurring_rules: { rule: IceCube::Rule.yearly.month_of_year(:october).day_of_week(monday: [2]) },    kind: :holiday, key: :columbus_day,            title: "Columbus Day", },
      { site_key: :any,   market_kind: :any,  recurring_rules: {},                              kind: :holiday, key: :veterans_day,            title: "Veteran's Day", },
      { site_key: :any,   market_kind: :any,  recurring_rules: {},                              kind: :holiday, key: :veterans_day_observed,      title: "Veteran's Day (observed)", },
      { site_key: :any,   market_kind: :any,  recurring_rules: { rule: IceCube::Rule.yearly.month_of_year(:november).day_of_week(thursday: [4]) }, kind: :holiday, key: :thanksgiving_day,        title: "Thanksgiving Day", },
      { site_key: :any,   market_kind: :any,  recurring_rules: {},                              kind: :holiday, key: :christmas_day,           title: "Christmas Day", },

      { site_key: :dchbx, market_kind: :any,  recurring_rules: {},                              kind: :holiday, key: :emancipation_day,        title: "Emancipation Day", },
      { site_key: :dchbx, market_kind: :any,  recurring_rules: {},                              kind: :holiday, key: :emancipation_day_observed,        title: "Emancipation Day (observed)", },
      # Inauguration Day:  January 20 every 4 years
      { site_key: :dchbx, market_kind: :any,  recurring_rules: { rule: IceCube::Rule.yearly(4).month_of_year(:january).day_of_month(20) }, kind: :holiday, key: :inauguration_day,        title: "Inauguration Day", },
      { site_key: :mhc,   market_kind: :any,  recurring_rules: { rule: IceCube::Rule.yearly.month_of_year(:april).day_of_week(monday: [3])},       kind: :holiday, key: :patriots_day,            title: "Patriot's Day", },
    ]

  # @shop_market_binder_payment_due_on ||= ScheduledEvent.day_of_month_for("shop_binder_payment_due_on") || Settings.aca.shop_market.binder_payment_due_on

  HOLIDAY_EVENT_KINDS = {
      new_years_day:          { site_key: :any,   market_kind: :any,  recurring_rules: {},  kind: :holiday, title: "New Year's Day", },
      new_years_day_observed: { site_key: :any,   market_kind: :any,  recurring_rules: {},  kind: :holiday,  title: "New Year's Day (observed)", },
    }




  def holiday_schedule(start_on = Time.utc(2017,1,1)) # 2017-01-1 00:00:00 UTC)
    IceCube::Schedule.new(now = start_on) do |schedule|
      HOLIDAY_EVENT_KINDS.each do |holiday|
        schedule.add_recurrence_rule(holiday.recurring_rules) if recurring_rules.size > 0
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

  field :site_key,        type: Symbol
  field :market_kind,     type: Symbol
  field :frequency,       type: Symbol
  field :settings_key,    type: String

  field :title,           type: String
  field :key,             type: String
  field :description,     type: String
  field :kind,            type: Symbol, default: :system
  field :start_on,        type: Date
  field :one_time,        type: Boolean, default: true
  field :recurring_rules, type: Hash
  field :offset_rule,     type: Integer, default: 0

  index({key: 1})
  index({site_key: 1, market_kind: 1, kind: 1})

  scope :events_for,  ->(date = TimeKeeper.date_of_record) { where(:start_on => date) }
  scope :events_for,  ->(date = TimeKeeper.date_of_record) { where(:start_on => date) }

  embeds_many :event_exceptions

  validates_presence_of :kind, :key, :one_time, :start_on, :message => "fields kind, event_key can't be empty"

  validates :kind,
    inclusion: { in: KINDS, message: "%{value} is not a valid scheduled event kind" },
    allow_blank: false



  def recurring_rules=(new_rule)
    if RecurringSelect.is_valid_rule?(new_rule)
      super(RecurringSelect.dirty_hash_to_rule(new_rule).to_hash)
    else
      super(nil)
    end
  end

  def start_on=(new_time)
    if new_time.blank?
      super(TimeKeeper.date_of_record)
    else
      super(Date.strptime(new_time, "%m/%d/%Y").to_date) rescue super(new_time.to_date) 
    end
  end

  def rule
    IceCube::Rule.from_hash recurring_rules
  end

  def schedule(start)
    schedule = IceCube::Schedule.new(start)
    schedule.add_recurrence_rule(rule)
    event_exceptions.each do |exception|
      schedule.add_exception_time(exception.time)
    end
    schedule
  end


  def calendar_events(start, offset_rule)
    if recurring_rules.blank?
      [self]
    else
      end_date = start.end_of_year.end_of_month.end_of_week
      schedule(start_on).occurrences(end_date).map do |val|
        val = val + offset_rule.day + 1.day if val.saturday?
        val = val + offset_rule.day if val.sunday?
        ScheduledEvent.new(id: id, key: key, start_on: val, one_time: false)
      end
    end
  end

  def self.day_of_month_for(key)    
    begin   
      ScheduledEvent.find_by!(key: key).start_on.day    
    rescue Mongoid::Errors::DocumentNotFound    
       nil   
    end     
  end
end
