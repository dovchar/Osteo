require 'test_helper'

class DatePairInputTest < ActionView::TestCase
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
end
