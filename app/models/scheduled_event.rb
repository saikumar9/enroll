class ScheduledEvent
  include Mongoid::Document
  include Mongoid::Timestamps
  include ScheduledEventService

  KINDS   = %W(system holiday)
  SYSTEM_EVENTS = %W(binder_payment_due_date publish_due_date_of_month ivl_monthly_open_enrollment_due_on shop_initial_application_publish_due_day_of_month shop_renewal_application_monthly_open_enrollment_end_on
                       shop_renewal_application_publish_due_day_of_month shop_renewal_application_force_publish_day_of_month shop_open_enrollment_monthly_end_on shop_group_file_new_enrollment_transmit_on
                       shop_group_file_update_transmit_day_of_week)


  field :title, type: String
  field :event_name, type: String
  field :description, type: String
  field :kind, type: String, default: "system"
  field :start_on, type: Date
  field :one_time, type: Boolean, default: true
  field :recurring_rules, type: Hash
  field :offset_rule, type: Integer, default: 0

  index({event_name: 1})
  index({start_on: 1, kind: 1})

  scope :events_for,  ->(date = TimeKeeper.date_of_record) { where(:start_on => date) }

  embeds_many :event_exceptions

  validates_presence_of :kind, :event_name, :one_time, :start_on, :message => "fields kind, event_name can't be empty"

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
        ScheduledEvent.new(id: id, event_name: event_name, start_on: val, one_time: false)
      end
    end
  end

  def self.day_of_month_for(event_name)    
    begin   
      ScheduledEvent.find_by!(event_name: event_name).start_on.day    
    rescue Mongoid::Errors::DocumentNotFound    
       nil   
    end     
  end
end
