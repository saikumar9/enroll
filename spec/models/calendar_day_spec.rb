require 'rails_helper'

RSpec.describe CalendarDay, type: :model, :dbclean => :after_each do

  context "An instance is created" do
    context "with no arguments" do
      let(:params) {{}}

      it "should throw error" do
        expect{CalendarDay.new()}.to raise_error(ArgumentError)
      end
    end

    context "with an invalid argument type" do
      let(:now)           { "bad string!" }
      let(:calendar_day)  { CalendarDay.new(now) }

      it "should throw error" do
        expect{CalendarDay.new()}.to raise_error(ArgumentError)
      end
    end

    context "with a valid Date argument" do
      let(:now)           { Date.today }
      let(:calendar_day)  { CalendarDay.new(now) }

      it "should initialize" do
        expect(calendar_day.today).to eq now
      end
    end    

    context "with a valid DateTime argument" do
      let(:now)           { DateTime.now }
      let(:calendar_day)  { CalendarDay.new(now) }

      it "should initialize to beginning of day" do
        expect(calendar_day.today).to eq now.beginning_of_day
      end
    end

    context "and no Scheduled Events are scheduled on that day" do
      let(:monday)    { Date.today.end_of_week + 1.day }
      let(:sunday)    { Date.today.end_of_week}

      it "day should not include any Scheduled Events" do
        expect(CalendarDay.new(monday).scheduled_events).to eq []
      end

      it "day should not be a holiday" do
        expect(CalendarDay.new(monday).is_holiday?).to be_falsey
      end

      context "and the date falls on a weekday" do
        it "day should be a business day" do
          expect(CalendarDay.new(monday).is_business_day?).to be_truthy
        end

        it "day should not be a weekend day" do
          expect(CalendarDay.new(monday).is_weekend?).to be_falsey
        end
      end

      context "and the date falls on a weekend" do
        it "day should not be a business day" do
          expect(CalendarDay.new(sunday).is_business_day?).to be_falsey
        end

        it "day should be a weekend day" do
          expect(CalendarDay.new(sunday).is_weekend?).to be_truthy
        end
      end
    end

    context "and there are multiple Scheduled Events in database" do
      let(:may_holiday_event_name)        { "memorial_day" }
      let(:september_holiday_event_name)  { "labor_day" }
      let(:system_event_name)             { "shop_group_file_new_enrollment_transmit_on" }
      let(:first_monday_in_september)     { Date.new(Date.today.year, 9, 6).monday }
      let(:last_monday_in_may)            { (Date.new(Date.today.year, 6, 1) - 1.day).monday }
      let(:last_monday_in_may)            { (Date.new(Date.today.year, 6, 1) - 1.day).monday }
      let!(:memorial_day)                 { ScheduledEvent.create(start_on: last_monday_in_may, 
                                              kind: "holiday", 
                                              title: "Memorial Day", 
                                              event_name: may_holiday_event_name, 
                                              one_time: true) }

      let!(:labor_day)                    { ScheduledEvent.create(start_on: first_monday_in_september, 
                                              kind: "holiday", 
                                              title: "Labor Day",
                                              event_name: september_holiday_event_name, 
                                              one_time: true) }

      let!(:system_event)                 { ScheduledEvent.create(start_on: last_monday_in_may, 
                                              title: "",
                                              event_name: system_event_name, 
                                              one_time: true) }

      it "should find multiple events" do
        expect(ScheduledEvent.all.size).to be > 1
      end

      context "and the last Monday in May has two scheduled events" do

        it "day should have two scheduled events" do
          expect(CalendarDay.new(last_monday_in_may).scheduled_events.size).to eq 2
        end

        it "day should be a holiday" do
          expect(CalendarDay.new(last_monday_in_may).is_holiday?).to be_truthy
        end

        it "the holiday event name should match" do
          expect(CalendarDay.new(last_monday_in_may).holiday_events.first.event_name).to eq may_holiday_event_name
        end

        it "the system event name should match" do
          expect(CalendarDay.new(last_monday_in_may).system_events.first.event_name).to eq system_event_name
        end

        it "the event should be retrievable by event_name" do
          expect(CalendarDay.new(last_monday_in_may).scheduled_events_for(system_event_name).first.event_name).to eq system_event_name
        end
      end

      context "and the first Monday in September has one scheduled event" do
        it "day should have one scheduled event" do
          expect(CalendarDay.new(first_monday_in_september).scheduled_events.size).to eq 1
        end

        it "the event name should match" do
          expect(CalendarDay.new(first_monday_in_september).holiday_events.first.event_name).to eq september_holiday_event_name
        end

        it "an event_name not scheduled on that date should not be found" do
          expect(CalendarDay.new(first_monday_in_september).scheduled_events_for(system_event_name).size).to eq 0
        end

      end
    end
  end

end
