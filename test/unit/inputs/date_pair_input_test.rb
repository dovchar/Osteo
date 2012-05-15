require 'test_helper'
require_relative 'inputs_test_helper'

class DatePairInputTest < ActionView::TestCase
  include InputsTestHelper

  test "simple_form DatePairInput" do
    event = Calendar::Event.new
    event.title = 'date around midnight'
    event.starts_at = Time.new(2012, 02, 15, 23, 21)
    event.ends_at = event.starts_at + 1.hour
    event.all_day = false

    # Specify a fake url otherwise form_for fails
    html = simple_form_for(event, url: '') { |f| f.input :starts_at, as: :date_pair }
    assert_select_in html, 'input.date_pair#event_starts_at_date'
    assert html.include? '2012-02-15'
    assert_select_in html, 'input.date_pair#event_starts_at_time'
    assert html.include? '11:30pm' # Fails if Calendar::Event::STEP_MINUTE is changed

    html = simple_form_for(event, url: '') { |f| f.input :ends_at, as: :date_pair }
    assert_select_in html, 'input.date_pair#event_ends_at_date'
    assert html.include? '2012-02-16'
    assert_select_in html, 'input.date_pair#event_ends_at_time'
    assert html.include? '12:30am'
  end
end
