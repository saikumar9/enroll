FactoryGirl.define do
  factory :calendars_scheduled_events, class: 'Calendars::ScheduledEvent' do
    key :martin_luther_king_day
    title 'Martin Luther King, Jr. Day'
    recurring { IceCube::Rule.yearly.month_of_year(:february).day_of_week(monday: [3]) }
    start_time { TimeKeeper.datetime_of_record }
    is_holiday true
    
    trait :empty_recurring do
      recurring nil
    end

    trait :recurring do
     recurring { IceCube::Rule.yearly.month_of_year(:december).day_of_month(25) }  
    end

    # trait :next_friday do
    #   start_time { Date.today.sunday + 5.day }
    # end

    # trait :next_saturday do
    #   start_time { Date.today.sunday + 6.day }
    # end

    # trait :next_sunday do
    #   start_time { Date.today.sunday }
    # end
  end
end
