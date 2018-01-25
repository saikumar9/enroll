class Exchanges::ScheduledEventsController < ApplicationController
  layout "two_column"

  def new
  	@scheduled_event = ScheduledEvent.new
  end

  def list
  end

  def create
    params.permit!
    scheduled_event = ScheduledEvent.new(scheduled_event_params)
    if scheduled_event.save!
      scheduled_event.update_attributes!(one_time: false) if scheduled_event.recurring_rules.present?
      @flash_message = 'Event successfully created'
      @flash_type = 'success'
      @calendar_events = load_calendar_events
      @available_calendars = Calendar.all
      redirect_to main_app.exchanges_scheduled_events_path
    else
      @flash_message = scheduled_event.errors.values.flatten.to_sentence
      @flash_type = 'error'
      @scheduled_event = scheduled_event
      render :new
    end
  end
  
  def create_calendar
    @new_calendar = Calendar.new(calendar_params)
    if @new_calendar.save!
      @available_calendars = Calendar.all
    else
      @flash_message = @new_calendar.errors.values.flatten.to_sentence
      @flash_type = 'error'
    end
    redirect_to main_app.exchanges_scheduled_events_path
  end

  def edit
  end

  def show
    begin
      @time = Date.strptime(params[:time], "%m/%d/%Y").to_date
    rescue
      @time = @scheduled_event.start_time
    end
  end

  def update
    params.permit!
    if scheduled_event.update_attributes!(scheduled_event_params)
      scheduled_event.event_exceptions.delete_all
      if scheduled_event.recurring_rules.present?
        scheduled_event.update_attributes!(one_time: false)
      else
        scheduled_event.update_attributes!(one_time: true)
      end
      @scheduled_event = scheduled_event
      @flash_message = "Event successfully updated"
      @flash_type = 'success'
      render :list
    else
      @flash_message = scheduled_event.errors.values.flatten.to_sentence
      @flash_type = 'error'
      @scheduled_event = scheduled_event
      render :edit
    end
  end

  def index
    @available_calendars = Calendar.all
    @new_calendar = Calendar.new()
    @scheduled_event = ScheduledEvent.new
  end

  def destroy
    if scheduled_event.destroy
      @flash_message = 'Current Event was successfully destroyed.'
      @flash_type = 'success'
    else
      @flash_message = "We encountered an error trying to remove this occurence"
      @flash_type = 'alert'
    end
    @calendar_events = load_calendar_events
  end

  def current_events
    if params[:event] == 'system'
      @events = ScheduledEvent::SYSTEM_EVENTS
    end
    render partial: 'exchanges/scheduled_events/get_events_field', locals: { event: params[:event] }

  end

  def delete_current_event
    if scheduled_event.event_exceptions.create!(time: params[:time])
      @flash_message = "#{scheduled_event.event_name.humanize} on #{params[:time]} was successfully removed"
      @flash_type = 'success'
    else
      @flash_message = "We encountered an error trying to remove this occurence"
      @flash_type = 'alert'
    end
    @calendar_events = load_calendar_events
  end
  
  def get_calendar_events
    calendar_events = ScheduledEvent.where(calendar_id:params[:id])
    @available_calendars = Calendar.all
    @new_calendar = Calendar.new()
    render json: calendar_events.map {|event| {title:event.event_name.gsub('_',' ').titleize,start:event.start_time,all_day:true, one_time:event.one_time,recurring_rules:event.recurring_rules,color:event.color,id:event.id} }
  end

  private

    helper_method :scheduled_event, :scheduled_events
    
    def load_calendar_events
      scheduled_events.flat_map do |e|
        if params.key?("start_date")
          e.calendar_events(Date.strptime(params.fetch(:start_date, TimeKeeper.date_of_record ), "%m/%d/%Y").to_date, e.offset_rule)
        else
          e.calendar_events((params.fetch(:start_date, TimeKeeper.date_of_record)).to_date, e.offset_rule)
        end
      end
    end

    def scheduled_event_params
      params.require(:scheduled_event).permit(:type, :event_name, :start_time, :recurring_rules, :one_time, :offset_rule, :author_id, :calendar_id, :color)
    end
    
    def calendar_params
      params.require(:calendar).permit(:name, :organization, :author_id, :color)
    end

    def scheduled_event
      @scheduled_event ||= ScheduledEvent.find(params[:id])
    end

    def scheduled_events
      @scheduled_events ||= ScheduledEvent.all
    end
end
