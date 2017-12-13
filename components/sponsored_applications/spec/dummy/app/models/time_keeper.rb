class TimeKeeper
  include CoreModelConcerns::TimeKeeperConcern

  def date_of_record
    tl_value = thread_local_date_of_record
    return tl_value unless tl_value.blank?
    found_value = Rails.cache.fetch(CACHE_KEY) do
      #TODO: brianweiner where is log defined
      #log("date_of_record not available for TimeKeeper - using Date.current")
      Date.current.strftime("%Y-%m-%d")
    end
    Date.strptime(found_value, "%Y-%m-%d")
  end

  def self.set_date_of_record(new_date)
    new_date = new_date.to_date
    if instance.date_of_record != new_date
      if instance.date_of_record > new_date
        #log("Attempt made to set date to past: #{new_date}", {:severity => :error})
        raise StandardError, "system may not go backward in time"
      else
        number_of_days = (new_date - instance.date_of_record).to_i
        number_of_days.times do
          instance.set_date_of_record(instance.date_of_record + 1.day)
          instance.push_date_of_record
          instance.push_date_change_event
        end
      end
    end
    instance.date_of_record
  end
end
