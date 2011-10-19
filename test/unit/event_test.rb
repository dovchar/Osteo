require 'test_helper'

class EventTest < ActiveSupport::TestCase

  test "event attributes must not be empty" do
    event = Event.new
    assert event.invalid?
    assert event.errors[:title].any?
    assert event.errors[:starts_at].any?
    assert event.errors[:ends_at].any?

    assert !event.save
    assert_equal "can't be blank", event.errors[:title].join('; ')
  end

  test "event end date must be after start date" do
    event = Event.new(title: 'Hello', starts_at: 1, ends_at: 0)
    assert event.invalid?
    assert_equal "can't be before the starting date", event.errors[:ends_at].join('; ')

    event = Event.new(title: 'Hello', starts_at: 0, ends_at: 0)
    assert event.valid?

    event = Event.new(title: 'Hello', starts_at: 0, ends_at: 1)
    assert event.valid?
  end

end
