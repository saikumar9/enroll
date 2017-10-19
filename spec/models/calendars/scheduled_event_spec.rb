require 'rails_helper'

RSpec.describe Calendars::ScheduledEvent, kind: :model do
  # subject { Calendars::ScheduledEvent.new }

  it "has a valid factory" do
    expect(create(:calendars_scheduled_events)).to be_valid
  end

  it { is_expected.to validate_presence_of :key }
  it { is_expected.to validate_presence_of :start_time }
  it { is_expected.to validate_presence_of :recurring }
  it { is_expected.to validate_presence_of :is_holiday }



  let(:key)               { :memorial_day }
  let(:start_time)        { TimeKeeper.datetime_of_record }
  let(:memorial_day_rule) { IceCube::Rule.yearly.month_of_year(:may).day_of_week(monday: [-1]) }
  let(:is_holiday)        { true }

  let(:valid_params) do
    {
      key: key,
      start_time: start_time,
      recurring: memorial_day_rule,
    }
  end

  context ".new" do
    context "with no arguments" do
      let(:params) {{}}

      it "should not save" do
        expect(Calendars::ScheduledEvent.new(**params).save).to be_falsey
      end
    end

    context "with no key" do
      let(:params) {valid_params.except(:key)}

      it "should fail validation" do
        expect(Calendars::ScheduledEvent.create(**params).errors[:key].any?).to be_truthy
      end
    end

    context "with no start_time" do
      let(:params) {valid_params.except(:start_time)}

      it "should fail validation" do
        expect(Calendars::ScheduledEvent.create(**params).errors[:start_time].any?).to be_truthy
      end
    end


    context "with all valid arguments" do
      let(:params) { valid_params }
      let(:scheduled_event) { Calendars::ScheduledEvent.new(**params) }

      it "should be valid" do
        expect(scheduled_event.valid?).to be_truthy
      end

      it "should save" do
        expect(scheduled_event.save).to be_truthy
      end

      context "and it is saved" do
        let!(:saved_scheduled_event) do
          event = scheduled_event
          event.save
          event
        end

        it "should be findable" do
          expect(Calendars::ScheduledEvent.find(saved_scheduled_event.id).id.to_s).to eq saved_scheduled_event.id.to_s
        end
      end
    end

  end

  context "and the scheduled event Is Not a business_day_only type" do

    context "and the event occurs on a business day" do
      it "should schedule the event on that day"
    end

    context "and the event occurs on a weekend day" do
      it "should schedule the event on that day"
    end

    context "and the event occurs on a holiday" do
      it "should schedule the event on that day"
    end
  end


  context "and the scheduled event Is a business_day_only type" do

    context "and event occurs on a business day" do
      it "should schedule the event on that business day"
    end

    context "and event occurs on a weekend day" do

      context "and the event has a 0 day offset" do
        it "should reschedule the event to the next Monday"
      end

        context "and the event has a 3 day offset" do
          it "should reschedule the event to the next Wednesday"
        end

    end

    context "and event occurs on a holiday " do

      context "that falls on a Monday" do
        context "and the event has a 0 day offset" do
          it "should reschedule the event to the next Tuesday"
        end

        context "and the event has a 2 day offset" do
          it "should reschedule the event to the next Thursday"
        end
      end


      context "that falls on a Friday" do
        context "and the event has a 0 day offset" do
          it "should reschedule the event to the next Monday"
        end

        context "and the event has a 1 day offset" do
          it "should reschedule the event to the next Tuesday"
        end
      end

    end

    context "and event occurs on a weekend and the next Monday is a holiday" do

      context "and the event has a 0 day offset" do
        it "should reschedule the event to the next Tuesday"
      end

      context "and the event has a 2 days offset" do
        it "should reschedule the event to the next Thursday"
      end
    end


    context "and a monthly recurring scheduled event is changed for one month" do

      context "and the scheduled event Is Not a business_day_only type" do
        context "and the event date is changed to a weekend day" do
        end

        context "and the event date is change to a holiday" do
        end
      end

      context "and the scheduled event Is a business_day_only type" do
        context "and the event date is changed to a weekend day" do
        end

        context "and the event date is change to a holiday" do
        end
      end

    end

  end


  context "convert recurring rules into hash" do

  	let(:event_params) { {
      kind: :holiday,
      title: "Christmas Day",
      key: :christmas_day,
      offset_rule: 3,
      recurring: "{\"interval\":1,\"until\":null,\"count\":null,\"validations\":{\"day_of_week\":{},\"day_of_month\":[22]},\"rule_type\":\"IceCube::MonthlyRule\",\"week_start\":0}",
      :start_time => Date.today
    }}
    value = "{\"interval\":1,\"until\":null,\"count\":null,\"validations\":{\"day_of_week\":{},\"day_of_month\":[22]},\"rule_type\":\"IceCube::MonthlyRule\",\"week_start\":0}"
  	let(:scheduled_event1) {Calendars::ScheduledEvent.new(event_params)}
  	recurring_hash = {:validations=>{:day_of_month=>[22]}, :rule_type=>"IceCube::MonthlyRule", :interval=>1}
  	it "convert recurring rules into hash" do
  	  expect(scheduled_event1.recurring).to eq recurring_hash
  	end
  end

  context "set start time to current if entered value is blank" do
  	value = ""
  	let(:event_params) { {
      kind: :holiday,
      title: "Christmas Day",
      key: :christmas_day,
      offset_rule: 3,
      recurring: "{\"interval\":1,\"until\":null,\"count\":null,\"validations\":{\"day_of_week\":{},\"day_of_month\":[22]},\"rule_type\":\"IceCube::MonthlyRule\",\"week_start\":0}",
      :start_time => value
    }}
  	let(:scheduled_event1) {Calendars::ScheduledEvent.new(event_params)}
  	it "set start time to current if entered value is blank" do
  	  expect(scheduled_event1.start_time).to eq TimeKeeper.date_of_record
  	end
  end

  context "set start time value is entered" do
  	value = "05/24/2017"
  	let(:event_params) { {
      kind: :holiday,
      title: "Christmas Day",
      key: :christmas_day,
      offset_rule: 3,
      recurring: "{\"interval\":1,\"until\":null,\"count\":null,\"validations\":{\"day_of_week\":{},\"day_of_month\":[22]},\"rule_type\":\"IceCube::MonthlyRule\",\"week_start\":0}",
      :start_time => value
    }}
  	let(:scheduled_event1) {Calendars::ScheduledEvent.new(event_params)}
  	it "set start time value is entered" do
  	  expect(scheduled_event1.start_time).to eq Date.strptime(value, "%m/%d/%Y").to_date
  	end
  end
  
  context "Calendar Event" do
    let(:schedule_event_with_empty_recurring) { FactoryGirl.create(:calendars_scheduled_events, :empty_recurring, offset_rule: 3)}
    let(:scheduled_event_recurring) { FactoryGirl.create(:calendars_scheduled_events, :empty_recurring, offset_rule: 3)}
    let(:friday_offset_1) { FactoryGirl.create(:calendars_scheduled_events, :start_time_friday, offset_rule: 1)}
    let(:friday_offset_2) { FactoryGirl.create(:calendars_scheduled_events, :start_time_friday, offset_rule: 2) }
    let(:sunday_offset_1) { FactoryGirl.create(:calendars_scheduled_events, :start_time_sunday, offset_rule: 1) }
    let(:saturday_offset_1) { FactoryGirl.create(:calendars_scheduled_events, :start_time_saturday, offset_rule: 4) }

    it "should get self event" do
      array = schedule_event_with_empty_recurring.calendar_events(schedule_event_with_empty_recurring.start_time, 4)
      expect(array.length).to eq 1
      expect(array).to eq [schedule_event_with_empty_recurring]
    end

    it "should get same start time for self event" do
      array = schedule_event_with_empty_recurring.calendar_events(schedule_event_with_empty_recurring.start_time, 4)
      expect(array.length).to eq 1
      expect(array.collect(&:start_time)).to eq [schedule_event_with_empty_recurring.start_time]
    end

    it "should get 3 occurences" do
      array = scheduled_event_recurring.calendar_events(scheduled_event_recurring.start_time, 4)
      expect(array.length).to eq 1
      expect(array.collect(&:start_time)).to eq [scheduled_event_recurring.start_time]
    end

    it "should not reschedule for weekday for any offset" do
      events = friday_offset_1.calendar_events(friday_offset_1.start_time, friday_offset_1.offset_rule)
      expect(events.first.start_time.strftime('%A')).to eq 'Friday'
    end

    it "should reschedule to Tuesday for Sunday scheduled Event with offset 2" do
      events = friday_offset_2.calendar_events(friday_offset_2.start_time, friday_offset_2.offset_rule)
      expect(events.first.start_time.strftime('%A')).to eq 'Friday'
    end

    it "should reschedule to Monday for Sunday scheduled Event with offset 1" do
      sunday_offset_1.update_attributes(recurring: "{\"interval\":1,\"until\":null,\"count\":null,\"validations\":{\"day_of_week\":{},\"day_of_month\":[#{Date.today.sunday.day}]},\"rule_type\":\"IceCube::MonthlyRule\",\"week_start\":0}")
      events = sunday_offset_1.calendar_events(sunday_offset_1.start_time, sunday_offset_1.offset_rule)
      expect(events.first.start_time.strftime('%A')).to eq 'Monday'
    end

    it "should reschedule to Thursday for Saturday scheduled Event with offset 4" do
      saturday_offset_1.update_attributes(recurring: "{\"interval\":1,\"until\":null,\"count\":null,\"validations\":{\"day_of_week\":{},\"day_of_month\":[#{(Date.today.sunday + 6.day).day}]},\"rule_type\":\"IceCube::MonthlyRule\",\"week_start\":0}")
      events = saturday_offset_1.calendar_events(saturday_offset_1.start_time, saturday_offset_1.offset_rule)
      expect(events.first.start_time.strftime('%A')).to eq 'Thursday'
    end
  end
end
