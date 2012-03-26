require 'test_helper'

class EventsHelperTest < ActionView::TestCase
  test "time should round" do
    time = Time.new(2011, 11, 13, 03, 50).round(10.minutes)
    assert_equal Time.new(2011, 11, 13, 03, 50), time

    time = Time.new(2011, 11, 13, 03, 51).round(10.minutes)
    assert_equal Time.new(2011, 11, 13, 03, 50), time

    time = Time.new(2011, 11, 13, 03, 59).round(10.minutes)
    assert_equal Time.new(2011, 11, 13, 04, 00), time

    time = Time.new(2011, 11, 13, 13, 42, 24).round()
    assert_equal Time.new(2011, 11, 13, 13, 42, 00), time

    time = Time.new(2011, 11, 13, 13, 42, 24).round(1.hour)
    assert_equal Time.new(2011, 11, 13, 14, 00, 00), time
  end

  test "time should parse jquery datetime" do
    model = 'event'
    field = 'starts_at'

    params = { model => { 'starts_at_date' => '2011-12-31', 'starts_at_time' => '01:14:00' } }
    Time.parse_jquery_datetime_select(params, model, field)
    assert_equal Time.new(2011, 12, 31, 01, 14, 00), params[model][field]
    assert_nil params[model]["#{field}_date"]
    assert_nil params[model]["#{field}_time"]

    params = { model => { 'starts_at_date' => '2011-12-31', 'starts_at_time' => '' } }
    Time.parse_jquery_datetime_select(params, model, field)
    assert_equal Time.new(2011, 12, 31, 00, 00, 00), params[model][field]
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
    current_year = Time.now.year # 2012
    year_before = Time.now.year - 1 # 2011

    # Entire day, this year (current_year)
    starts_at = Time.new(current_year, 01, 31, 14, 30)
    str = Time.to_event_format(starts_at, nil, :all_day)
    assert_equal 'Tue, January 31', str

    starts_at = Time.new(current_year, 01, 31, 14, 30)
    str = Time.to_event_format(starts_at, starts_at, :all_day)
    assert_equal 'Tue, January 31', str

    # Entire day, in year_before
    starts_at = Time.new(year_before, 01, 31, 14, 30)
    str = Time.to_event_format(starts_at, nil, :all_day)
    assert_equal "Mon, January 31, #{year_before}", str

    # Same day, this year (current_year)
    starts_at = Time.new(current_year, 01, 31, 14, 30)
    ends_at = Time.new(current_year, 01, 31, 15, 00)
    str = Time.to_event_format(starts_at, ends_at)
    assert_equal 'Tue, January 31, 2:30pm &ndash; 3pm', str

    starts_at = Time.new(current_year, 01, 31, 14, 00)
    ends_at = Time.new(current_year, 01, 31, 15, 30)
    str = Time.to_event_format(starts_at, ends_at)
    assert_equal 'Tue, January 31, 2pm &ndash; 3:30pm', str

    # Same day, in year_before
    starts_at = Time.new(year_before, 01, 31, 14, 30)
    ends_at = Time.new(year_before, 01, 31, 15, 00)
    str = Time.to_event_format(starts_at, ends_at)
    assert_equal "Mon, January 31, #{year_before}, 2:30pm &ndash; 3pm", str

    starts_at = Time.new(year_before, 01, 31, 14, 00)
    ends_at = Time.new(year_before, 01, 31, 15, 30)
    str = Time.to_event_format(starts_at, ends_at)
    assert_equal "Mon, January 31, #{year_before}, 2pm &ndash; 3:30pm", str

    # Across days, this year (current_year)
    starts_at = Time.new(current_year, 01, 31, 14, 30)
    ends_at = Time.new(current_year, 10, 31, 15, 00)
    str = Time.to_event_format(starts_at, ends_at)
    assert_equal 'Tue, January 31, 2:30pm &ndash; Wed, October 31, 3pm', str

    starts_at = Time.new(current_year, 01, 31, 14, 00)
    ends_at = Time.new(current_year, 10, 31, 15, 30)
    str = Time.to_event_format(starts_at, ends_at)
    assert_equal 'Tue, January 31, 2pm &ndash; Wed, October 31, 3:30pm', str

    # Across days, this year (current_year), entire days
    starts_at = Time.new(current_year, 01, 31, 14, 30)
    ends_at = Time.new(current_year, 10, 31, 15, 00)
    str = Time.to_event_format(starts_at, ends_at, :all_day)
    assert_equal 'Tue, January 31 &ndash; Wed, October 31', str

    # Across days, in year_before
    starts_at = Time.new(year_before, 01, 31, 14, 30)
    ends_at = Time.new(year_before, 10, 31, 15, 00)
    str = Time.to_event_format(starts_at, ends_at)
    assert_equal "Mon, January 31, #{year_before}, 2:30pm &ndash; Mon, October 31, 3pm", str

    starts_at = Time.new(year_before, 01, 31, 14, 00)
    ends_at = Time.new(year_before, 10, 31, 15, 30)
    str = Time.to_event_format(starts_at, ends_at)
    assert_equal "Mon, January 31, #{year_before}, 2pm &ndash; Mon, October 31, 3:30pm", str

    # Across days, in year_before, entire days
    starts_at = Time.new(year_before, 01, 31, 14, 30)
    ends_at = Time.new(year_before, 10, 31, 15, 00)
    str = Time.to_event_format(starts_at, ends_at, :all_day)
    assert_equal "Mon, January 31, #{year_before} &ndash; Mon, October 31", str

    # Across years
    starts_at = Time.new(year_before, 01, 31, 14, 30)
    ends_at = Time.new(current_year, 10, 31, 15, 00)
    str = Time.to_event_format(starts_at, ends_at)
    assert_equal "Mon, January 31, #{year_before}, 2:30pm &ndash; Wed, October 31, #{current_year}, 3pm", str

    starts_at = Time.new(year_before, 01, 31, 14, 00)
    ends_at = Time.new(current_year, 10, 31, 15, 30)
    str = Time.to_event_format(starts_at, ends_at)
    assert_equal "Mon, January 31, #{year_before}, 2pm &ndash; Wed, October 31, #{current_year}, 3:30pm", str

    # Across years, entire days
    starts_at = Time.new(year_before, 01, 31, 14, 30)
    ends_at = Time.new(current_year, 10, 31, 15, 00)
    str = Time.to_event_format(starts_at, ends_at, :all_day)
    assert_equal "Mon, January 31, #{year_before} &ndash; Wed, October 31, #{current_year}", str
  end

  test "event_time_tag" do
    event = Event.new
    event.title = "date around midnight"
    event.starts_at = Time.new(2012, 02, 15, 23, 20)
    event.ends_at = event.starts_at + 1.hour

    html = event_time_tag(event.starts_at, event.ends_at)
    assert_equal 'Wed, February 15, 10:20pm &ndash; 11:20pm', html
  end

  test "jquery_datetime_select" do
    event = Event.new
    event.title = 'date around midnight'
    event.starts_at = Time.new(2012, 02, 15, 23, 23)
    event.ends_at = event.starts_at + 1.hour

    starts_at_html = jquery_datetime_select :event, :starts_at, :date_before_time, event.starts_at
    assert starts_at_html.include? '2012-02-15'
    assert starts_at_html.include? '23:20'

    ends_at_html = jquery_datetime_select :event, :ends_at, :date_before_time, event.ends_at
    assert ends_at_html.include? '2012-02-16'
    assert ends_at_html.include? '00:20'
  end
end
