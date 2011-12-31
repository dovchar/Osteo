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

  test "time should parse jquery datetime" do
    model = 'event'
    field = 'starts_at'

    params = { model => { 'starts_at_date' => '2011-12-31', 'starts_at_time' => '01:14:00' } }
    Time.parse_jquery_datetime_select(params, model, field)
    assert_equal params[model][field], Time.new(2011, 12, 31, 01, 14, 00)
    assert_nil params[model]["#{field}_date"]
    assert_nil params[model]["#{field}_time"]

    params = { model => { 'starts_at_date' => '2011-12-31', 'starts_at_time' => '' } }
    Time.parse_jquery_datetime_select(params, model, field)
    assert_equal params[model][field], Time.new(2011, 12, 31, 00, 00, 00)
    assert_nil params[model]["#{field}_date"]
    assert_nil params[model]["#{field}_time"]

    params = { model => { 'starts_at_date' => '', 'starts_at_time' => '01:14:00' } }
    Time.parse_jquery_datetime_select(params, model, field)
    assert_not_nil params[model][field]
    assert_nil params[model]["#{field}_date"]
    assert_nil params[model]["#{field}_time"]
  end

  test "time should not parse jquery datetime" do
    model = 'event'
    field = 'starts_at'

    params = { model => { } }
    Time.parse_jquery_datetime_select(params, model, field)
    assert_nil params[model][field]
    assert_nil params[model]["#{field}_date"]
    assert_nil params[model]["#{field}_time"]

    params = { model => { 'starts_at_date' => '', 'starts_at_time' => '' } }
    Time.parse_jquery_datetime_select(params, model, field)
    assert_nil params[model][field]
    assert_nil params[model]["#{field}_date"]
    assert_nil params[model]["#{field}_time"]

    params = { model => { 'starts_at_date' => 'bad date', 'starts_at_time' => 'bad time' } }
    Time.parse_jquery_datetime_select(params, model, field)
    assert_nil params[model][field]
    assert_nil params[model]["#{field}_date"]
    assert_nil params[model]["#{field}_time"]
  end
end
