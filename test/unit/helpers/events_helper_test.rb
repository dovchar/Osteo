require 'test_helper'

class EventsHelperTest < ActionView::TestCase
  test "datepair_tag" do
    event = Event.new
    event.title = 'date around midnight'
    Time.use_zone(Event::TIME_ZONE) do
      event.starts_at = Time.zone.local(2012, 02, 15, 23, 21)
      event.ends_at = event.starts_at + 1.hour
    end
    event.all_day = false

    html = datepair_tag(event.starts_at, event.ends_at, event.all_day)
    assert_equal 'Wed, February 15, 11:21pm &ndash; Thu, February 16, 12:21am', html
  end

  test "datepair_tag with another time zone" do
    old_zone = Event::TIME_ZONE
    Event::TIME_ZONE = 'Greenland'
    test_datepair_tag
    Event::TIME_ZONE = old_zone
  end

  test "simple_form DatePairInput" do
    event = Event.new
    event.title = 'date around midnight'
    event.starts_at = Time.new(2012, 02, 15, 23, 21)
    event.ends_at = event.starts_at + 1.hour
    event.all_day = false

    #TODO
    #html = datepair_select :event, event.starts_at, event.ends_at, event.all_day
    #assert html.include? '2012-02-15'
    #assert html.include? '11:30pm' # Fails if Event::STEP_MINUTE is changed
    #assert html.include? '2012-02-16'
    #assert html.include? '12:30am'
  end

  test "should parse DatePairInput request parameters" do
    model = 'event'
    field = 'starts_at'
    date = 'starts_at_date'
    time = 'starts_at_time'

    params = { model => { date => '2011-12-31', time => '01:14am' } }
    parse_datepair(params, model, field)
    assert_equal Time.new(2011, 12, 31, 01, 14, 00), Time.parse(params[model][field])
    assert_nil params[model][date]
    assert_nil params[model][time]

    params = { model => { date => '2011-12-31', time => '' } }
    parse_datepair(params, model, field)
    assert_equal Time.new(2011, 12, 31, 00, 00, 00), Time.parse(params[model][field])
    assert_nil params[model][date]
    assert_nil params[model][time]

    params = { model => { date => '', time => '01:14am' } }
    parse_datepair(params, model, field)
    assert params[model][field].include?('01:14')
    assert_nil params[model][date]
    assert_nil params[model][time]
  end

  test "should not parse invalid DatePairInput request parameters" do
    model = 'event'
    field = 'starts_at'
    date = 'starts_at_date'
    time = 'starts_at_time'

    params = nil
    parse_datepair(params, model, field)
    assert_nil params

    params = { }
    parse_datepair(params, model, field)
    assert_nil params[model]

    params = { model => { } }
    parse_datepair(params, model, field)
    assert_nil params[model][field]
    assert_nil params[model][date]
    assert_nil params[model][time]

    params = { model => { date => '', time => '' } }
    parse_datepair(params, model, field)
    assert_nil params[model][field]
    assert_nil params[model][date]
    assert_nil params[model][time]

    params = { model => { date => 'bad date', time => 'bad time' } }
    parse_datepair(params, model, field)
    assert_nil params[model][field]
    assert_nil params[model][date]
    assert_nil params[model][time]
  end
end
