require 'test_helper'
require_relative 'inputs_test_helper'

class DatePairInputTest < ActionView::TestCase
  include InputsTestHelper

  test "simple_form DatePairInput" do
    event = Event.new
    event.title = 'date around midnight'
    event.starts_at = Time.new(2012, 02, 15, 23, 21)
    event.ends_at = event.starts_at + 1.hour
    event.all_day = false

    html = with_input_for event, :starts_at, :date_pair
    assert_select 'input.date_pair#event_starts_at_date'
    assert html.include? '2012-02-15'
    assert_select 'input.date_pair#event_starts_at_time'
    assert html.include? '11:30pm' # Fails if Calendar::Event::STEP_MINUTE is changed

    html = with_input_for event, :ends_at, :date_pair
    assert_select 'input.date_pair#event_ends_at_date'
    assert html.include? '2012-02-16'
    assert_select 'input.date_pair#event_ends_at_time'
    assert html.include? '12:30am'
  end
end
