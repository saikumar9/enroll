FactoryGirl.define do
  factory :scheduled_event do
  	kind 'holiday'
  	event_name 'Christmas'
    start_on { Date.new(2017, 1, 1) }
    one_time true
    offset_rule 3

	  trait :empty_recurring_rules do
	    recurring_rules nil
	  end

	  trait :recurring_rules do
	   recurring_rules { }  
	  end

	  trait :start_on_friday do
	    start_on { Date.today.sunday + 5.day }
	  end

	  trait :start_on_saturday do
	    start_on { Date.today.sunday + 6.day }
	  end

	  trait :start_on_sunday do
	    start_on { Date.today.sunday }
	  end
	end
end