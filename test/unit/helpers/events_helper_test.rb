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

  test "time should format two events" do
    # FIXME The tests will fail when year 2012 will be past

    # Entire day, this year (2012)
    starts_at = Time.new(2012, 01, 31, 14, 30)
    str = Time.to_event_format(starts_at, nil, :all_day)
    assert_equal 'Tue, January 31', str

    starts_at = Time.new(2012, 01, 31, 14, 30)
    str = Time.to_event_format(starts_at, starts_at, :all_day)
    assert_equal 'Tue, January 31', str

    # Entire day, in 2011
    starts_at = Time.new(2011, 01, 31, 14, 30)
    str = Time.to_event_format(starts_at, nil, :all_day)
    assert_equal 'Mon, January 31, 2011', str

    # Same day, this year (2012)
    starts_at = Time.new(2012, 01, 31, 14, 30)
    ends_at = Time.new(2012, 01, 31, 15, 00)
    str = Time.to_event_format(starts_at, ends_at)
    assert_equal 'Tue, January 31, 2:30pm &ndash; 3pm', str

    starts_at = Time.new(2012, 01, 31, 14, 00)
    ends_at = Time.new(2012, 01, 31, 15, 30)
    str = Time.to_event_format(starts_at, ends_at)
    assert_equal 'Tue, January 31, 2pm &ndash; 3:30pm', str

    # Same day, in 2011
    starts_at = Time.new(2011, 01, 31, 14, 30)
    ends_at = Time.new(2011, 01, 31, 15, 00)
    str = Time.to_event_format(starts_at, ends_at)
    assert_equal 'Mon, January 31, 2011, 2:30pm &ndash; 3pm', str

    starts_at = Time.new(2011, 01, 31, 14, 00)
    ends_at = Time.new(2011, 01, 31, 15, 30)
    str = Time.to_event_format(starts_at, ends_at)
    assert_equal 'Mon, January 31, 2011, 2pm &ndash; 3:30pm', str

    # Across days, this year (2012)
    starts_at = Time.new(2012, 01, 31, 14, 30)
    ends_at = Time.new(2012, 10, 31, 15, 00)
    str = Time.to_event_format(starts_at, ends_at)
    assert_equal 'Tue, January 31, 2:30pm &ndash; Wed, October 31, 3pm', str

    starts_at = Time.new(2012, 01, 31, 14, 00)
    ends_at = Time.new(2012, 10, 31, 15, 30)
    str = Time.to_event_format(starts_at, ends_at)
    assert_equal 'Tue, January 31, 2pm &ndash; Wed, October 31, 3:30pm', str

    # Across days, this year (2012), entire days
    starts_at = Time.new(2012, 01, 31, 14, 30)
    ends_at = Time.new(2012, 10, 31, 15, 00)
    str = Time.to_event_format(starts_at, ends_at, :all_day)
    assert_equal 'Tue, January 31 &ndash; Wed, October 31', str

    # Across days, in 2011
    starts_at = Time.new(2011, 01, 31, 14, 30)
    ends_at = Time.new(2011, 10, 31, 15, 00)
    str = Time.to_event_format(starts_at, ends_at)
    assert_equal 'Mon, January 31, 2011, 2:30pm &ndash; Mon, October 31, 3pm', str

    starts_at = Time.new(2011, 01, 31, 14, 00)
    ends_at = Time.new(2011, 10, 31, 15, 30)
    str = Time.to_event_format(starts_at, ends_at)
    assert_equal 'Mon, January 31, 2011, 2pm &ndash; Mon, October 31, 3:30pm', str

    # Across days, in 2011, entire days
    starts_at = Time.new(2011, 01, 31, 14, 30)
    ends_at = Time.new(2011, 10, 31, 15, 00)
    str = Time.to_event_format(starts_at, ends_at, :all_day)
    assert_equal 'Mon, January 31, 2011 &ndash; Mon, October 31', str

    # Across years
    starts_at = Time.new(2011, 01, 31, 14, 30)
    ends_at = Time.new(2012, 10, 31, 15, 00)
    str = Time.to_event_format(starts_at, ends_at)
    assert_equal 'Mon, January 31, 2011, 2:30pm &ndash; Wed, October 31, 2012, 3pm', str

    starts_at = Time.new(2011, 01, 31, 14, 00)
    ends_at = Time.new(2012, 10, 31, 15, 30)
    str = Time.to_event_format(starts_at, ends_at)
    assert_equal 'Mon, January 31, 2011, 2pm &ndash; Wed, October 31, 2012, 3:30pm', str

    # Across years, entire days
    starts_at = Time.new(2011, 01, 31, 14, 30)
    ends_at = Time.new(2012, 10, 31, 15, 00)
    str = Time.to_event_format(starts_at, ends_at, :all_day)
    assert_equal 'Mon, January 31, 2011 &ndash; Wed, October 31, 2012', str
  end
end
