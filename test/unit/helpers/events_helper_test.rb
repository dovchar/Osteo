require 'test_helper'

class EventsHelperTest < ActionView::TestCase
  test "time should round" do
    time = Time.new(2011, 11, 13, 03, 50, 00).round(10.minutes)
    assert_equal time, Time.new(2011, 11, 13, 03, 50, 00)

    time = Time.new(2011, 11, 13, 03, 51, 00).round(10.minutes)
    assert_equal time, Time.new(2011, 11, 13, 03, 50, 00)

    time = Time.new(2011, 11, 13, 03, 59, 00).round(10.minutes)
    assert_equal time, Time.new(2011, 11, 13, 04, 00, 00)

    time = Time.new(2011, 11, 13, 13, 42, 24).round()
    assert_equal time, Time.new(2011, 11, 13, 13, 42, 00)

    time = Time.new(2011, 11, 13, 13, 42, 24).round(1.hour)
    assert_equal time, Time.new(2011, 11, 13, 14, 00, 00)
  end
end
