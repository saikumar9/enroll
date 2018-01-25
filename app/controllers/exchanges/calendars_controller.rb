class Exchanges::CalendarsController < ApplicationController
  
  def new
  	@calendar = Calendar.new
  end

  def list
  end

  def create
    params.permit!
    calendar = Calendar.new(calendar_params)
    if calendar.save!
      @flash_message = 'Event successfully created'
      @flash_type = 'success'
    else
      @flash_message = calendar.errors.values.flatten.to_sentence
      @flash_type = 'error'
      @calendar = calendar
      render :new
    end
  end

  def edit
  end

  def show
    begin
      @time = Date.strptime(params[:time], "%m/%d/%Y").to_date
    rescue
      @time = @calendar.start_time
    end
  end

  def update
    params.permit!
    if calendar.update_attributes!(calendar_params)
      calendar.event_exceptions.delete_all
      @calendar = calendar
      @flash_message = "Event successfully updated"
      @flash_type = 'success'
      render :list
    else
      @flash_message = calendar.errors.values.flatten.to_sentence
      @flash_type = 'error'
      @calendar = calendar
      render :edit
    end
  end

  def index
    @available_calendars = Calendar.all
  end

 
  private

  def calendar_params
    params.require(:calendar).permit(:name, :organization, :is_published, :author_id, :color)
  end

end