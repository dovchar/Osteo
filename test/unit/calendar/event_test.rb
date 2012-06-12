require 'test_helper'

module Calendar
  class EventTest < ActiveSupport::TestCase
    test "default attributes values" do
      event = Event.new
      now = Time.now.round_time(Calendar::Event::STEP_MINUTE.minutes)
      assert !event.title.blank?
      assert event.starts_at.to_i == now.to_i
      assert event.ends_at.to_i == (now + Calendar::Event::EVENT_LENGTH.minutes).to_i
    end

    test "save event with default attributes" do
      event = Event.new
      assert !event.title.blank?
      assert !event.starts_at.blank?
      assert !event.ends_at.blank?

      assert event.save
    end

    test "event end date must be after start date" do
      event = Event.new(title: 'Hello', starts_at: '2012-03-25 22:00:00 UTC', ends_at: '2012-03-25 21:00:00 UTC')
      assert event.invalid?
      assert_equal "can't be before the starting date", event.errors[:ends_at].join('; ')

      event = Event.new(title: 'Hello', starts_at: '2012-03-25 21:00:00 UTC', ends_at: '2012-03-25 21:00:00 UTC')
      assert event.valid?

      event = Event.new(title: 'Hello', starts_at: '2012-03-25 21:00:00 UTC', ends_at: '2012-03-25 22:00:00 UTC')
      assert event.valid?
    end

    fixtures 'calendar/events'

    test "ending_after scope" do
      events = Event.ending_after(Time.utc(2012, 05, 26, 00, 00)) # 1338069600
      assert_equal 1, events.size
      assert_equal 'Very long', events[0].title
      assert_equal calendar_events(:very_long).starts_at, events[0].starts_at
      assert_equal Time.utc(2012, 05, 23, 00, 00), events[0].starts_at
      assert_equal calendar_events(:very_long).ends_at, events[0].ends_at
      assert_equal Time.utc(2012, 06, 10, 00, 00), events[0].ends_at
    end

    test "starting_before scope" do
      events = Event.starting_before(Time.utc(2012, 07, 07, 00, 00)) # 1341698400
      assert_equal 4, events.size
    end
  end
end
