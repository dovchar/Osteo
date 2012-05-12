require 'test_helper'

class DatePairInputHelperTest < ActionView::TestCase
  include DatePairInputHelper

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
