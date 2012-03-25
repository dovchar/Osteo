require 'test_helper'

class EventTest < ActiveSupport::TestCase

  test "default attributes values" do
    event = Event.new
    assert !event.title.blank?
    assert event.starts_at.to_i == Time.now.to_i
    assert event.ends_at.to_i == (Time.now + 1.hour).to_i
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

end
