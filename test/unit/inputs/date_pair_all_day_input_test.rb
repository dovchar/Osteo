require 'test_helper'
require_relative 'inputs_test_helper'

class DatePairAllDayInputTest < ActionView::TestCase
  include InputsTestHelper

  test "simple_form DatePairAllDayInput" do
    event = Calendar::Event.new
    event.title = 'date around midnight'
    event.starts_at = Time.new(2012, 02, 15, 23, 21)
    event.ends_at = event.starts_at + 1.hour
    event.all_day = false

    html = simple_form_for(event, url: '') { |f| f.input :all_day, as: :date_pair_all_day }
    assert_select_in html, 'input.date_pair_all_day#event_all_day'
  end
end
